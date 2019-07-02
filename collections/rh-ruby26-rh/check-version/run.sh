#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable ${ENABLE_SCLS} "ruby -v" )
ret=$?

echo "$out"|grep -o 'ruby 2\.6'
exit $retcode

