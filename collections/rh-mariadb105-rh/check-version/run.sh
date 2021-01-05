#!/bin/bash


THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable $ENABLE_SCLS 'mysql -V')
retcode=$?

echo "$out"|grep -o 'Distrib 10\.5\.'

exit $retcode
