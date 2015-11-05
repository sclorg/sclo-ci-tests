#!/bin/bash


out=$(scl enable v8314 'echo -e "\000"| v8-shell')
retcode=$?

echo "$out"|grep -o '^V8 version 3\.14\.'

exit $retcode
