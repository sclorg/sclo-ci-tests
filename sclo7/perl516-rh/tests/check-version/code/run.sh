#!/bin/bash

out=$(scl enable perl516 "perl -v" )
ret=$?

echo "$out"|grep -o 'This is perl 5, version 16,'
exit $retcode

