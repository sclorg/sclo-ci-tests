#!/bin/bash

if [ $# -lt 2 ] ; then
  echo "Usage: `basename $0` <scl> <el_version{6|7|..}>" >&2
  exit 1
fi

sclname="$1" ; shift
el_version="$1" ; shift

pushd sclo$el_version/$sclname-rh >/dev/null
./runtests.sh
popd >/dev/null

for test in validate-pkg-list ; do
  pushd $test >/dev/null
  ./run.sh $sclname $el_version
  popd >/dev/null
done
