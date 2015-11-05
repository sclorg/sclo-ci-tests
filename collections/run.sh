#!/bin/bash

if [ "$#" -eq 0 ] ; then
  echo "Usage `basename $0` collection [ collection ... ]"
  exit 1
fi

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../common/functions.sh

while [ -n "$1" ] ; do
  namespace=$(get_scl_namespace $1 `os_major_version` | sed -e 's/-$//')
  $1-$namespace/run.sh
  shift
done
