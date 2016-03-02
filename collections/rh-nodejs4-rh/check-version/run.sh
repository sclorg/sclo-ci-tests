#!/bin/bash

out=$(scl enable rh-nodejs4 "node -v" )
ret=$?

echo "$out"|grep -o 'v4\.'
exit $retcode

