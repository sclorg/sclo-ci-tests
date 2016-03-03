#!/bin/bash


out=$(scl enable rh-ror42 'rails -v' 2>&1)
retcode=$?

echo "$out"|grep -o '^Rails 4\.2\.'

exit $retcode
