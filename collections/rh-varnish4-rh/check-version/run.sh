#!/bin/bash


out=$(scl enable rh-varnish4 'varnishd -V' 2>&1)
retcode=$?

echo "$out"|grep -o 'varnishd (varnish-4\.'

exit $retcode
