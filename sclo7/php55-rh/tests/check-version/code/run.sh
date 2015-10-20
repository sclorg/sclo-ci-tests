#!/bin/bash

out=$(scl enable php55 "php -v")
ret=$?

echo "$out"|grep -o 'PHP 5\.5\.'
exit $retcode

