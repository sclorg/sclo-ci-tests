#!/bin/bash


out=$(scl enable rh-varnish6 'varnishd -V' 2>&1)
retcode=$?

echo "$out"|grep -o 'varnishd (varnish-6\.'

exit $retcode
