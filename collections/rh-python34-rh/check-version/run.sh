#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../include.sh

out=$(scl enable $ENABLE_SCLS -- "python3.4 -V" 2>&1 )
ret=$?

echo "$out"|grep -o 'Python 3\.4\.'
exit $retcode

