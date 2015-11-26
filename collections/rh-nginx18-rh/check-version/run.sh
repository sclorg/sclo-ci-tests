#!/bin/bash


out=$(scl enable rh-nginx18 'nginx -v' 2>&1)
retcode=$?

echo "$out"|grep -o '^nginx version: nginx/1\.8\.'

exit $retcode
