#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

scl enable $ENABLE_SCLS -- postgresql-setup initdb
service "$SERVICE_NAME" start
exit $?
