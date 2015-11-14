#!/bin/bash

out=$(scl enable nodejs010 "node -v" )
ret=$?

echo "$out"|grep -o 'v0\.10\.'
exit $retcode

