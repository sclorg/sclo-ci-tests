#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable ${ENABLE_SCLS} -- scalac -version 2>&1)
ret=$?

echo "$out"|grep -o 'Scala compiler version 2\.10\.'
exit $?

