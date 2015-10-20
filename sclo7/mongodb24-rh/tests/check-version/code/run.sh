#!/bin/bash


out=$(scl enable mongodb24 'mongod --version')
retcode=$?

echo "$out"|grep -o '^db version v2\.4\.'

exit $retcode
