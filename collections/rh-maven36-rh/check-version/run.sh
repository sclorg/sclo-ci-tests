#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

out=$(scl enable $INSTALL_SCLS 'mvn -v')
retcode=$?

echo "$out"|grep -o 'Apache Maven 3\.6\.'

exit $retcode
