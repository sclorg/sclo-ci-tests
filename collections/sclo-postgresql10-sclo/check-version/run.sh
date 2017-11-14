#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable $ENABLE_SCLS 'postgres -V')
retcode=$?

echo "$out"|grep -o '^postgres (PostgreSQL) 10\.'

exit $retcode
