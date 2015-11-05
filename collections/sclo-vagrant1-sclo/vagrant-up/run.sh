#!/bin/bash

# we need to run this as root

service libvirtd start
syncdir=$(mktemp -d /tmp/sync-XXXXXX)
git clone https://github.com/CentOS/sig-core-t_functional $syncdir
cp Vagrantfile $syncdir
chmod u+x ./vagrant_test.sh
scl enable sclo-vagrant1 ./vagrant_test.sh $syncdir
exit $?
