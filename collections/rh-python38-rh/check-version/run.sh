#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../include.sh

out=$(scl enable $ENABLE_SCLS -- python -V 2>&1 )
ret=$?

echo "$out"|grep -o 'Python 3\.8\.'
exit $retcode

