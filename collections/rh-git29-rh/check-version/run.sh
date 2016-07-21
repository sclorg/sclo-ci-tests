#!/bin/bash

out=$(scl enable $INSTALL_SCLS 'git --version' )
ret=$?

echo "$out"|grep -o 'git version 2\.9\.'
exit $retcode

