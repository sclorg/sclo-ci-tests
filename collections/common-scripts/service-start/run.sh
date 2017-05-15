#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

set -e
for service in $SERVICE_NAME ; do
  if ! service "$service" start ; then
    service "$service" status
    exit 1
  fi
done
