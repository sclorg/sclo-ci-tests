#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/common/functions.sh

for scl in ${@-`get_collections_list`} ; do
  ${THISDIR}/collections/${scl}-$(get_scl_namespace "$scl")/run.sh
done
