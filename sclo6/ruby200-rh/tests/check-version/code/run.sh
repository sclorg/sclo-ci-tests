#!/bin/bash

out=$(scl enable ruby200 "ruby -v" )
ret=$?

echo "$out"|grep -o 'ruby 2\.0\.0'
exit $retcode

