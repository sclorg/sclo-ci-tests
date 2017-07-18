#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

# clean after previous tests
service $SERVICE_NAME stop || :
[ -d "${DATA_DIR}" ] && rm -rf "${DATA_DIR}"/*

CONFIG_DIR=${SYSCONF_DIR}/my.cnf.d
GARBD_CONFIG=${SYSCONF_DIR}/sysconfig/garb
IPS=$(hostname -I)
IP=${IPS%% *}

yum -y install ${SCL_GALERA_PKGS}
cat >"${CONFIG_DIR}"/my-galera.cnf <<EOF
[mysqld]
wsrep_cluster_address="gcomm://${IP}"
EOF

# scl_source returns non-zero return code from some reason
set +xe
source scl_source enable ${ENABLE_SCLS}
set -xe

galera_new_cluster

echo "SHOW GLOBAL STATUS LIKE 'wsrep_ready' \G" | mysql | grep ON

# start the second server manually (no systemd/init script)
DATA_DIR2=/var/lib/mysql2
SOCKET2=${DATA_DIR2}/mysql.sock
BASE_DIR=/opt/rh/rh-mariadb101/root/usr
CONFIG_FILE2=/etc/my2.cnf

# different ports require selinux re-settings, so far turning off selinux
selinux_bak=$(getenforce)
setenforce 0

cat >${CONFIG_FILE2} <<EOF
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
wsrep_on=1
wsrep_provider=${BASE_DIR}/lib64/galera/libgalera_smm.so
wsrep_cluster_name="my_wsrep_cluster"

wsrep_cluster_address='gcomm://${IP}:4567'
wsrep_provider_options='base_port=14567;'
wsrep_sst_receive_address=${IP}:2777
wsrep_provider_options='ist.recv_addr=${IP}:2888;'
wsrep_node_address=${IP}:14567

datadir=${DATA_DIR2}
socket=${SOCKET2}
port=3307
EOF

[ -d "${DATA_DIR2}" ] && rm -rf "${DATA_DIR2}"/*
mysql_install_db --rpm --datadir="${DATA_DIR2}" --user=mysql
${BASE_DIR}/libexec/mysqld --defaults-file=${CONFIG_FILE2} --user=mysql >${DATA_DIR2}/mysqld.log 2>&1 &
pid=$!

# make sure manually run daemon is killed on test end
cleanup() {
  kill $pid
  setenforce $selinux_bak
  service $SERVICE_NAME stop || :
}
trap cleanup EXIT

# wait till we can connect
for i in `seq 20` ; do
  echo 'SELECT 1' | mysql --socket ${SOCKET2} test &>/dev/null && break || :
  sleep 2
done
[ $i -eq 20 ] && echo "Error: Connection to new server #2 does not work"
echo "CREATE TABLE t1 (i INT); INSERT INTO t1 VALUES (42);" | mysql test
echo "SELECT * FROM t1 LIMIT 1 \G" | mysql --socket ${SOCKET2} test | grep 'i: 42'
echo "SHOW GLOBAL STATUS LIKE 'wsrep_ready' \G" | mysql | grep 'Value: ON'
echo "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size' \G" | mysql | grep 'Value: 2'
echo "SHOW GLOBAL STATUS LIKE 'wsrep_ready' \G" | mysql --socket ${SOCKET2} | grep 'Value: ON'
echo "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size' \G" | mysql --socket ${SOCKET2} | grep 'Value: 2'

# run garbd
cat >${GARBD_CONFIG} <<EOF
GALERA_NODES="${IP}:4567,${IP}:14567"
GALERA_GROUP="my_wsrep_cluster"
GALERA_OPTIONS='base_port=24567;'
EOF

service ${GARBD_SERVICE_NAME} stop || :
service ${GARBD_SERVICE_NAME} start
sleep 3
service ${GARBD_SERVICE_NAME} status
service ${GARBD_SERVICE_NAME} stop

