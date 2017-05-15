#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable ${ENABLE_SCLS} "node -v" )
ret=$?

echo "$out"|grep -o 'v6\.'
exit $retcode

