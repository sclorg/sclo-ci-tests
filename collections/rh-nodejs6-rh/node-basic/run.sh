#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

appfile=$(mktemp /tmp/testappXXXXXX.js)
echo 'console.log("Hello NodeJS");' >${appfile}

out=$(scl enable ${ENABLE_SCLS} "node ${appfile}" )
ret=$?

[ "$out" == "Hello NodeJS" ] || exit 1
exit $ret

