#!/bin/bash

# rh-ruby25 contains a bug in Bundler broke the common test case
# Below is rh-ruby25-specific workaround

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

yum install -y ${INSTALL_SCLS}-rubygem-bundler

username=testuser$$
homedir=/var/lib/test-home$$
mkdir -p $homedir
useradd -d $homedir $username
cp ${THISDIR}/Gemfile $homedir
chown -R $username:$username $homedir
su - $username -c "cd \$HOME ; scl enable $ENABLE_SCLS --  bundle --path \$(ruby -e 'Gem.user_dir')" || exit_fail "bundler failed"
userdel -r $username

exit $?
