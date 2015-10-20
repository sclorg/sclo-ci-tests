#!/bin/bash

out=$(scl enable rh-python34 "python3.4 -V" 2>&1 )
ret=$?

echo "$out"|grep -o 'Python 3\.4\.'
exit $retcode

