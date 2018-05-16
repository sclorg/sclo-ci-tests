#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

sed -i -e 's/#mmapv1:/mmapv1:/' -e 's/#smallFiles:.*/smallFiles: true/' /etc/opt/rh/rh-mongodb34/mongod.conf

service "$SERVICE_NAME" start
exit $?
