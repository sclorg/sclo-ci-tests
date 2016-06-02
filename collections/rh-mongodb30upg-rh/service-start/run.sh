#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

echo "smallfiles = true" >>/etc/opt/rh/rh-mongodb30upg/mongod.conf
service "$SERVICE_NAME" start
exit $?
