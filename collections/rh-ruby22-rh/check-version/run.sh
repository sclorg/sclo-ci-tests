#!/bin/bash

out=$(scl enable rh-ruby22 "ruby -v" )
ret=$?

echo "$out"|grep -o 'ruby 2\.2'
exit $retcode

