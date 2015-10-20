#!/bin/bash

out=$(scl enable python27 "python2.7 -V" 2>&1 )
ret=$?

echo "$out"|grep -o 'Python 2\.7\.'
exit $retcode

