#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

out=$(scl enable $ENABLE_SCLS -- ruby -e "puts 'Hello World'")
[ "$out" != "Hello World" ] && exit_fail "Basic test of ruby -e failed"

scl enable $ENABLE_SCLS -- gem install activeresource || exit_fail "gem activeresource couldn't be installed"

exit $?
