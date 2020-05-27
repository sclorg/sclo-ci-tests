#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable $ENABLE_SCLS "perl -v" )
ret=$?

echo "$out"|grep -o 'This is perl 5, version 30,'
exit $retcode

