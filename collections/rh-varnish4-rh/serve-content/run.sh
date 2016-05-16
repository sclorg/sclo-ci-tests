#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

set -ex

CONF=/etc/opt/rh/rh-varnish4/varnish/default.vcl
sed -i 's/8080/80/' $CONF

for service in $SERVICE_NAME ; do
  service "$service" restart
done

sleep 3

echo "Hello World" >${STATIC_DATA_DIR}/index.html
out=$(curl 127.0.0.1:6081)
[ "$out" == "Hello World" ]
res=$?

# in case of failure, print some diagnostics
if [ $res -ne 0 ] ; then
  yum -y install net-tools
  netstat -putna
fi

exit $res
