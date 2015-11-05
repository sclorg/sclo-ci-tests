#!/bin/bash

out=$(scl enable rh-perl520 "perl -v" )
ret=$?

echo "$out"|grep -o 'This is perl 5, version 20,'
exit $retcode

