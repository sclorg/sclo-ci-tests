#!/bin/bash

out=$(scl enable git19 'git --version' )
ret=$?

echo "$out"|grep -o 'git version 1\.9\.'
exit $retcode

