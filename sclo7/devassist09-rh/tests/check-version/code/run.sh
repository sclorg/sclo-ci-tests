#!/bin/bash


out=$(scl enable devassist09 'devassistant version')
retcode=$?

echo "$out"|grep -o '^DevAssistant 0\.9\.'

exit $retcode
