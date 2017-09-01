#!/bin/bash


out=$(scl enable rh-mongodb34 'mongod --version')
retcode=$?

echo "$out"|grep -o '^db version v3\.4\.'

exit $retcode
