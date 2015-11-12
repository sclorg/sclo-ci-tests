#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

out=$(scl enable $ENABLE_SCLS -- python -c "print('Hello World')")
[ "$out" != "Hello World" ] && exit_fail "Basic test of python -c failed"

scl enable $ENABLE_SCLS -- easy_install Django || exit_fail "easy_install Django couldn't be installed"

scl enable $ENABLE_SCLS -- pip install Flask || exit_fail "pip Flask couldn't be installed"

exit $?
