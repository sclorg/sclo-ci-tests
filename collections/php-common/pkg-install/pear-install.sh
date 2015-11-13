#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

yum install -y ${INSTALL_SCLS}-php-devel

# pear must be configured, so this does not work yet

scl enable ${ENABLE_SCLS} - <<'EOF'
  set -ex
  pear install Cache_Lite
EOF

