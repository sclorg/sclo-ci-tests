#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

if [ `os_major_version` -le 6 ] ; then
  service "$SERVICE_NAME" initdb
else
  scl enable $ENABLE_SCLS -- postgresql-setup initdb
fi
service "$SERVICE_NAME" start
exit $?
