#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

generate_repo_file "$INSTALL_SCLS"

yum install -y ${INSTALL_PKGS-$INSTALL_SCLS}
exit $?
