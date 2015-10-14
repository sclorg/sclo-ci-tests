#!/bin/bash

# we need to run this as root

service libvirtd start
git clone https://github.com/CentOS/sig-core-t_functional ~/sync
cp Vagrantfile ~/sync/
chmod u+x ./vagrant_test.sh
scl enable sclo-vagrant1 ./vagrant_test.sh
exit $?
