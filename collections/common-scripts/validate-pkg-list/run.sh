#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../include.sh

for scl in $INSTALL_SCLS ; do
  ${THISDIR}/../../../validate-pkg-list/run.sh $scl 7
done
