#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

source scl_source enable ${ENABLE_SCLS}

retval=0

HAPCFGPATH="${SYSCONF_DIR}/haproxy/haproxy.cfg"
HTTPDCFGPATH="/etc/httpd/conf/httpd.conf"
HTTP_FILE=/var/www/html/index.html
FILE_CONTENT="HAProxy Works"

yum -y install httpd

# Allow httpd to can network connect
setsebool httpd_can_network_connect 0

sed -i -e 's/^Listen 80/Listen 8008/g' "${HTTPDCFGPATH}"
cp "${THISDIR}/haproxy.cfg" "${HAPCFGPATH}"
haproxy -c -V -f "${HAPCFGPATH}"

service httpd start
service $SERVICE_NAME start
echo "${FILE_CONTENT}" >> "${HTTP_FILE}"
chmod 0644 "${HTTP_FILE}"
restorecon -v "${HTTP_FILE}"

out=$(curl http://localhost:80)

if ! echo "$out" | grep "${FILE_CONTENT}" ; then
  echo "HTTP response does not include '${FILE_CONTENT}'"
  retval=1
fi

service $SERVICE_NAME stop
service httpd stop

exit $retval

