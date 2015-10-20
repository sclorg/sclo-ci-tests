#!/bin/bash


out=$(scl enable httpd24 'httpd -v')
retcode=$?

echo "$out"|grep -o 'Server version: Apache/2\.4\.'

exit $retcode
