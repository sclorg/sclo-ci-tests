#!/bin/bash

# Flask is no longer supporting Python 2.7; install six library instead

THISDIR="$(dirname ${BASH_SOURCE[0]})"
source "${THISDIR}/../../../common/functions.sh"
source "${THISDIR}/../include.sh"

set -xe

install_build_tools

test "$(scl enable ${ENABLE_SCLS} -- python -c "print('Hello, World')")" = 'Hello, World' \
    || exit_fail "Basic test of python -c failed"

scl enable ${ENABLE_SCLS} -- easy_install pip || exit_fail "easy_install pip couldn't be installed"

scl enable ${ENABLE_SCLS} -- pip install six || exit_fail "pip six couldn't be installed"

scl enable ${ENABLE_SCLS} -- python -c "from six import b, u"

exit $?
