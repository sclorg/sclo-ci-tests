#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

generate_repo_file "$INSTALL_SCLS"

set -e

for rpkg in ruby193 ruby200 ruby22 ; do
  yum install -y ${INSTALL_SCLS} rh-passenger40-${rpkg} nginx16
  echo "Configuring and starting passenger with ${rpkg} ..."
  scl enable rh-passenger40 - <<"EOF"
    set -x
    rm -rf $HOME/approot
    mkdir -p $HOME/approot/public
    cd $HOME/approot
    echo "Hello World" >$HOME/approot/public/index.html
    passenger-config --root
    port=$(($$ % 500 + 10000))
    passenger start -p $port &
    sleep 5
    deamon_pid=$!
    out=$(curl 127.0.0.1:$port)
    [ "$out" == "Hello World" ] || exit 1
    kill $deamon_pid
    rm -rf $HOME/approot
EOF
  yum remove -y rh-passenger40\*
done

