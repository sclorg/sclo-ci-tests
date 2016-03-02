#!/bin/bash


out=$(scl enable rh-postgresql95 'postgres -V')
retcode=$?

echo "$out"|grep -o '^postgres (PostgreSQL) 9\.5\.'

exit $retcode
