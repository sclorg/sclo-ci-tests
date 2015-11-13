#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

set -ex

service "$SERVICE_NAME" start
echo "Hello World" >${STATIC_DATA_DIR}/index.html
out=$(curl 127.0.0.1)
[ "$out" == "Hello World" ]

