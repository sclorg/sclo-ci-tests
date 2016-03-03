#!/bin/bash


out=$(scl enable rh-maven33 'mvn -v')
retcode=$?

echo "$out"|grep -o '^Apache Maven 3\.3\.'

exit $retcode
