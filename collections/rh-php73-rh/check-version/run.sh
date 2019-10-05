#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable $ENABLE_SCLS "php -v")
ret=$?

echo "$out"|grep -o 'PHP 7\..\.'
exit $retcode

