#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -ex

[ -z "$HTTPD_SERVICE_NAME" ] && echo "Environment variable HTTPD_SERVICE_NAME must be set." && exit 1
[ -z "$PHP_HTTPD_PKGS" ] && echo "Environment variable PHP_HTTPD_PKGS must be set." && exit 1
[ -z "$STATIC_DATA_DIR" ] && echo "Environment variable STATIC_DATA_DIR must be set." && exit 1

yum install -y ${PHP_HTTPD_PKGS}

for service in ${HTTPD_SERVICE_NAME} ; do
  service "$service" restart
done

cat >${STATIC_DATA_DIR}/test.php <<'EOF'
<?php   
echo "This is a dynamic content.";
?>
EOF

out=$(curl 127.0.0.1/test.php)
[ "$out" == "This is a dynamic content." ]

