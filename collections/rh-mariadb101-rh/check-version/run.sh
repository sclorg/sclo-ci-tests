#!/bin/bash


out=$(scl enable rh-mariadb101 'mysql -V')
retcode=$?

echo "$out"|grep -o 'Distrib 10\.1\.'

exit $retcode
