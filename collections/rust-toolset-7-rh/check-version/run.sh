#!/bin/bash

ENABLE_SCLS=${ENABLE_SCLS:-rust-toolset-7}

out=$(scl enable $ENABLE_SCLS -- rustc --version|head -n 1)
retcode=$?

echo "$out"|grep -o '^rustc 1.19.'
exit $retcode
