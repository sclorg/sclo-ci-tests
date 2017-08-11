#!/bin/bash


out=$(scl enable rh-maven35 'mvn -v')
retcode=$?

echo "$out"|grep -o 'Apache Maven 3\.5\.'

exit $retcode
