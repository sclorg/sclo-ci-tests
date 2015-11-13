#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

yum install -y rh-ruby22-rubygem-bundler

username=testuser$$
homedir=/var/lib/test-home$$
mkdir -p $homedir
useradd -d $homedir $username
cp ${THISDIR}/Gemfile $homedir
chown -R $username:$username $homedir
su - $username -c "cd \$HOME ; scl enable $ENABLE_SCLS -- bundle" || exit_fail "bundler failed"
userdel -r $username

exit $?
