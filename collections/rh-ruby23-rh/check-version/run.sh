#!/bin/bash

out=$(scl enable rh-ruby23 "ruby -v" )
ret=$?

echo "$out"|grep -o 'ruby 2\.3'
exit $retcode

