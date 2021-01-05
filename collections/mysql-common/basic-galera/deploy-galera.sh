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

# deliberately starting with no address, it caused troubles with 10.4 and further
yum -y install ${SCL_GALERA_PKGS}
cat >"${CONFIG_DIR}"/my-galera.cnf <<EOF
[mysqld]
wsrep_cluster_address="gcomm://"
EOF

# scl_source returns non-zero return code from some reason
set +xe
source scl_source enable ${ENABLE_SCLS}
set -xe

sed -i -e 's/wsrep_on=.*$/wsrep_on=1/' "${CONFIG_DIR}"/galera.cnf

galera_new_cluster

sleep 2

echo "SHOW GLOBAL STATUS LIKE 'wsrep_ready' \G" | mysql | grep ON

# start the second server manually (no systemd/init script)
DATA_DIR2=/var/lib/mysql2
SOCKET2=${DATA_DIR2}/mysql.sock
CONFIG_FILE2=/etc/my2.cnf

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
wsrep_sst_receive_address=${IP}
wsrep_provider_options='ist.recv_addr=${IP}:14568;'
wsrep_node_address=${IP}:14567

datadir=${DATA_DIR2}
socket=${SOCKET2}
port=3307
EOF

# The port to listen on for Incremental State Transfer (ist.recv_addr) must be allowed
semanage port -a -t mysqld_port_t -p tcp 14568 || :

[ -d "${DATA_DIR2}" ] && rm -rf "${DATA_DIR2}"/*
mysql_install_db --rpm --datadir="${DATA_DIR2}" --user=mysql
${BASE_DIR}/libexec/mysqld --defaults-file=${CONFIG_FILE2} --user=mysql >${DATA_DIR2}/mysqld.log 2>&1 &
pid=$!

# make sure manually run daemon is killed on test end
cleanup() {
  kill $pid
  service $SERVICE_NAME stop || :
  sed -i -e 's/wsrep_on=.*$/wsrep_on=0/' "${CONFIG_DIR}"/galera.cnf
}
trap cleanup EXIT

# wait till we can connect
for i in `seq 20` ; do
  echo 'SELECT 1' | mysql --socket ${SOCKET2} mysql &>/dev/null && break || :
  sleep 2
done
[ $i -eq 20 ] && echo "Error: Connection to new server #2 does not work" && exit 1
echo "CREATE DATABASE test1;" | mysql
echo "CREATE TABLE t1 (i INT); INSERT INTO t1 VALUES (42);" | mysql test1
# leave some time for sync
sleep 3
echo "SHOW GLOBAL STATUS LIKE 'wsrep_ready' \G" | mysql | grep 'Value: ON'
echo "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size' \G" | mysql | grep 'Value: 2'
echo "SHOW GLOBAL STATUS LIKE 'wsrep_ready' \G" | mysql --socket ${SOCKET2} | grep 'Value: ON'
echo "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size' \G" | mysql --socket ${SOCKET2} | grep 'Value: 2'
echo "SELECT * FROM t1 LIMIT 1 \G" | mysql --socket ${SOCKET2} test1 | grep 'i: 42'

# run garbd
cat >${GARBD_CONFIG} <<EOF
GALERA_NODES="${IP}:4567 ${IP}:14567"
GALERA_GROUP="my_wsrep_cluster"
GALERA_OPTIONS='base_port=24567;'
EOF

service ${GARBD_SERVICE_NAME} stop || :
service ${GARBD_SERVICE_NAME} start
sleep 3
service ${GARBD_SERVICE_NAME} status
service ${GARBD_SERVICE_NAME} stop

