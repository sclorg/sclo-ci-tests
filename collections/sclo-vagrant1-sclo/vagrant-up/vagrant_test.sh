#!/bin/bash

if [ "$#" -ne 1 ] ; then
  echo "Usage: `basename $0` <dir-with-VagrantFile>"
  exit 1
fi

cd $1
vagrant up
vagrant ssh -c 'cd sync; sudo env "PATH=$PATH" ./runtests.sh'
exit $?

