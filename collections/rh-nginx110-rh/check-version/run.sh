#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable ${ENABLE_SCLS} 'nginx -v' 2>&1)
retcode=$?

echo "$out"|grep -o '^nginx version: nginx/1\.10\.'

exit $retcode
