#!/bin/bash


out=$(scl enable ror40 'rails -v' 2>&1)
retcode=$?

echo "$out"|grep -o '^Rails 4\.0\.'

exit $retcode
