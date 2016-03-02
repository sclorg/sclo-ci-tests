#!/bin/bash

appfile=$(mktemp /tmp/testappXXXXXX.js)
echo 'console.log("Hello NodeJS");' >${appfile}

out=$(scl enable rh-nodejs4 "node ${appfile}" )
ret=$?

[ "$out" == "Hello NodeJS" ] || exit 1
exit $ret

