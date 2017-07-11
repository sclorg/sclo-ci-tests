#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

generate_repo_file "$INSTALL_SCLS"

# scldevel packages conflict across similar collections from their nature
# so to avoid expected conflicts, let's remove scldevel packages
# from all collections first
yum remove -y \*-scldevel

set -e

for SCL in $INSTALL_SCLS ; do
  yum install -y ${YUM_OPTS:-} $EXCLUDE_PKGS ${SCL}\*
done
