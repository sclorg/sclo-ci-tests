#!/bin/bash


out=$(scl enable rh-maven36 'mvn -v')
retcode=$?

echo "$out"|grep -o 'Apache Maven 3\.6\.'

exit $retcode
