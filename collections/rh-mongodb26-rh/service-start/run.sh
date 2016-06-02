h!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

grep -e '^[[:space:]]*smallfiles' /etc/opt/rh/rh-mongodb26/mongod.conf &>/dev/null || echo "smallfiles = true" >>/etc/opt/rh/rh-mongodb26/mongod.conf
service "$SERVICE_NAME" start
exit $?
