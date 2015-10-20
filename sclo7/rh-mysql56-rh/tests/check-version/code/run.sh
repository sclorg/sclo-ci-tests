#!/bin/bash


out=$(scl enable rh-mysql56 'mysql -V')
retcode=$?

echo "$out"|grep -o 'Distrib 5\.6\.'

exit $retcode
