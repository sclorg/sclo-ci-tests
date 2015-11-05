#!/bin/bash

out=$(scl enable ruby193 "ruby -v" )
ret=$?

echo "$out"|grep -o 'ruby 1\.9\.3'
exit $retcode

