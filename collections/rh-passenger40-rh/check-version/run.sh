#!/bin/bash


out=$(scl enable ruby193 rh-passenger40 'passenger --version')
retcode=$?

echo "$out"|grep -o '^Phusion Passenger version 4\.0\.'

exit $retcode
