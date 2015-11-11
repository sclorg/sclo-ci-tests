#!/bin/bash

# Runs all tests for one or more collections, specified by arguments
# The arguments are collection names without namespace suffix
# (namespace is added from configuration), e.g. mysql55
# If no collection is specified, then all collections are tested.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/common/functions.sh

for scl in ${@-`get_collections_list`} ; do
  ${THISDIR}/collections/${scl}-$(get_scl_namespace "$scl")/run.sh
done
