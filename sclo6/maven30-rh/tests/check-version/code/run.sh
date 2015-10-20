#!/bin/bash


out=$(scl enable maven30 'mvn -v')
retcode=$?

echo "$out"|grep -o '^Apache Maven 3\.0\.'

exit $retcode
