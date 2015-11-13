#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

set -ex

cat >${CONFIG_D_DIR}/test.conf <<EOF
server {
	listen 80;
	server_name myhost.com;
	root ${STATIC_DATA_DIR};
	index index.php index.html;
}
EOF

service "$SERVICE_NAME" restart
mkdir -p ${STATIC_DATA_DIR}
echo "Hello World" >${STATIC_DATA_DIR}/index.html
out=$(curl 127.0.0.1)
[ "$out" == "Hello World" ]

