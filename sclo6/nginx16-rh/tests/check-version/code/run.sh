#!/bin/bash


out=$(scl enable nginx16 'nginx -v' 2>&1)
retcode=$?

echo "$out"|grep -o '^nginx version: nginx/1\.6\.'

exit $retcode
