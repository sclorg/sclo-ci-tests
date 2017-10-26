#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

service $SERVICE_NAME restart

if [ "$(getenforce)" != 'Enforcing' ] ; then
  echo "SELinux not in enforcing mode."
fi

exitcode=0

expected_mysqld_cont=mysqld_t
if ps -AZ | grep -e 'mysqld$' | grep -e ${expected_mysqld_cont} ; then
  echo "mysqld running under expected ${expected_mysqld_cont} context"
else
  echo "mysqld running under wrong context:"
  ps -AZ | grep -e 'mysqld$'
  exitcode=1
fi

expected_sock_cont=mysqld_var_run_t
if ls -AZ /var/lib/mysql/mysql.sock | grep -e ${expected_sock_cont} ; then
  echo "mysql.sock has expected ${expected_sock_cont} context"
else
  echo "mysql.sock has wrong context:"
  ls -AZ /var/lib/mysql/mysql.sock
  exitcode=2
fi

exit $exitcode
