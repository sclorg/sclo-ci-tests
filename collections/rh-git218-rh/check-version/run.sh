#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable $INSTALL_SCLS 'git --version' )
ret=$?

echo "$out"|grep -o 'git version 2\.18\.'
exit $retcode

