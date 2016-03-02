#!/bin/bash


out=$(scl enable rh-mongodb32 'mongod --version')
retcode=$?

echo "$out"|grep -o '^db version v3\.2\.'

exit $retcode
