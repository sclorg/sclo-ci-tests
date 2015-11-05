#!/bin/bash


out=$(scl enable postgresql92 'postgres -V')
retcode=$?

echo "$out"|grep -o '^postgres (PostgreSQL) 9\.2\.'

exit $retcode
