#!/bin/bash


out=$(scl enable rh-ror41 'rails -v' 2>&1)
retcode=$?

echo "$out"|grep -o '^Rails 4\.1\.'

exit $retcode
