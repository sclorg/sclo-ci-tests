#!/bin/bash


out=$(scl enable rh-mongodb36 'mongod --version')
retcode=$?

echo "$out"|grep -o '^db version v3\.6\.'

exit $retcode
