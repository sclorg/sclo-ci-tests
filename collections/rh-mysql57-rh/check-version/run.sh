#!/bin/bash


out=$(scl enable rh-mysql57 'mysql -V')
retcode=$?

echo "$out"|grep -o 'Distrib 5\.7\.'

exit $retcode
