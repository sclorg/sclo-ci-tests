#!/bin/bash

for test in validate-pkg-list ; do
  pushd $test >/dev/null
  ./run.sh $@
  popd >/dev/null
done
