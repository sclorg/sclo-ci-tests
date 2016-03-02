#!/bin/bash


out=$(scl enable rh-mongodb30upg 'mongod --version')
retcode=$?

echo "$out"|grep -o '^db version v3\.0\.'

exit $retcode
