#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})

# we need to run this as root

yum -y install git qemu-kvm
service libvirtd start
syncdir=$(mktemp -d /tmp/sync-XXXXXX)
git clone https://github.com/CentOS/sig-core-t_functional $syncdir
cp $THISDIR/Vagrantfile $syncdir
chmod u+x $THISDIR/vagrant_test.sh
scl enable sclo-vagrant1 "$THISDIR/vagrant_test.sh $syncdir"
exit $?
