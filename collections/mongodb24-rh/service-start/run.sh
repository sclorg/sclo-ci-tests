h!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

echo "smallfiles = true" >>/opt/rh/rh-mongodb26/root/etc/mongodb.conf
service "$SERVICE_NAME" start
exit $?
