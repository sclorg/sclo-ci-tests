#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable ${ENABLE_SCLS} 'rails -v' 2>&1)
retcode=$?

echo "$out"|grep -o '^Rails 5\.0\.'

exit $retcode
