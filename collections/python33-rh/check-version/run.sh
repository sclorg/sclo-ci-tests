#!/bin/bash

out=$(scl enable python33 "python3.3 -V" 2>&1 )
ret=$?

echo "$out"|grep -o 'Python 3\.3\.'
exit $retcode

