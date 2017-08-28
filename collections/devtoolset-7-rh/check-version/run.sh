#!/bin/bash


out=$(scl enable $ENABLE_SCLS 'gcc --version' | head -n 1)
retcode=$?

echo "$out"|grep -o '^gcc (GCC) 7\.1\.'

exit $retcode
