#!/bin/bash

out=$(scl enable rh-php56 "php -v")
ret=$?

echo "$out"|grep -o 'PHP 5\.6\.'
exit $retcode

