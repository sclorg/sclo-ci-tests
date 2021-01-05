#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

${THISDIR}/bundler.sh
