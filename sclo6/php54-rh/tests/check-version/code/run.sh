#!/bin/bash

out=$(scl enable php54 "php -v")
ret=$?

echo "$out"|grep -o 'PHP 5\.4\.'
exit $retcode

