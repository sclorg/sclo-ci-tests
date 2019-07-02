#!/bin/bash


THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

generate_repo_file "$INSTALL_SCLS"

out=$(scl enable $ENABLE_SCLS 'redis-cli --version')
retcode=$?

echo "$out" | grep -e 'redis-cli 5\.'

exit $retcode
