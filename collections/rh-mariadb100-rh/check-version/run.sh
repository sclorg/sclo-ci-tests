#!/bin/bash


out=$(scl enable rh-mariadb100 'mysql -V')
retcode=$?

echo "$out"|grep -o 'Distrib 10\.0\.'

exit $retcode
