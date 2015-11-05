#!/bin/bash

for test in validate-pkg-list validate-install ; do
  pushd $test >/dev/null
  ./run.sh $@
  popd >/dev/null
done
