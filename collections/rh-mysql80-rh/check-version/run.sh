#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable $ENABLE_SCLS 'mysql -V')
retcode=$?

echo "$out" | grep -o '\(Distrib\|Ver\) 8\.0\.'

exit $?
