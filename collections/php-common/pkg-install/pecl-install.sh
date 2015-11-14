#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

yum install -y ${INSTALL_SCLS}-php-devel ${INSTALL_SCLS}-php-pear libxml2-devel

scl enable ${ENABLE_SCLS} - <<'EOF'
  set -ex
  # if module is already installed, another install fails,
  # so try to remove it before and ignore error here
  pecl uninstall xmldiff || :
  pecl install xmldiff
EOF

