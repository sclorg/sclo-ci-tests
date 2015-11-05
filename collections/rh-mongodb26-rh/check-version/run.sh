#!/bin/bash


out=$(scl enable rh-mongodb26 'mongod --version')
retcode=$?

echo "$out"|grep -o '^db version v2\.6\.'

exit $retcode
