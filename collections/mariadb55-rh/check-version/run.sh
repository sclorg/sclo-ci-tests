#!/bin/bash


out=$(scl enable mariadb55 'mysql -V')
retcode=$?

echo "$out"|grep -o 'Distrib 5\.5\.'

exit $retcode
