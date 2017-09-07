#!/bin/bash


out=$(scl enable rh-varnish5 'varnishd -V' 2>&1)
retcode=$?

echo "$out"|grep -o 'varnishd (varnish-5\.'

exit $retcode
