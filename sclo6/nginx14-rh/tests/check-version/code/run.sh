#!/bin/bash


out=$(scl enable nginx14 'nginx -v' 2>&1)
retcode=$?

echo "$out"|grep -o '^nginx version: nginx/1\.4\.'

exit $retcode
