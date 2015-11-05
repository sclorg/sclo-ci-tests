h!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

echo "smallfiles = true" >>/opt/rh/mongodb24/root/etc/mongodb.conf
service "$SERVICE_NAME" start
exit $?
