#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

if ! scl enable $ENABLE_SCLS 'haproxy -v' | grep -e '1\.8\.' ; then
  echo "Wrong version:"
  scl enable $ENABLE_SCLS 'haproxy -v'
  exit 1
fi
