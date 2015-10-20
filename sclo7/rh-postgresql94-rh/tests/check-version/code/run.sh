#!/bin/bash


out=$(scl enable rh-postgresql94 'postgres -V')
retcode=$?

echo "$out"|grep -o '^postgres (PostgreSQL) 9\.4\.'

exit $retcode
