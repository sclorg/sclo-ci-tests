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

if ps -AZ | grep -e 'mysqld$' | grep -e mysqld_t ; then
  echo "mysqld running under expected mysqld_t context"
else
  echo "mysqld running under wrong context"
  exit 1
fi

if ls -AZ /var/lib/mysql/mysql.sock | grep -e mysqld_db_t ; then
  echo "mysql.sock has expected mysqld_db_t context"
else
  echo "mysql.sock has wrong context"
  exit 1
fi

