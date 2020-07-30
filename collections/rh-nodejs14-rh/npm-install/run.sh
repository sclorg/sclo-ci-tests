#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

yum install -y $INSTALL_SCLS

username=testuser$$
homedir=/var/lib/test-home$$
mkdir -p $homedir
useradd -d $homedir $username
chown -R $username:$username $homedir
su - $username -c "cd \$HOME ; scl enable $ENABLE_SCLS -- npm install bower" || exit_fail "npm install failed"
userdel -r $username

exit $?
