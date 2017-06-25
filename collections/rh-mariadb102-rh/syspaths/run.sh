#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

yum install -y ${YUM_OPTS:-} ${$INSTALL_SCLS}*-syspaths

service mariadb start

echo 'select 1;' | mysql || exit $?
man mysql >/dev/null || exit $?

service mariadb stop
