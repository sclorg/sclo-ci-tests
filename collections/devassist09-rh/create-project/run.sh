#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

scl enable $INSTALL_SCLS - <<"EOF"
  set -ex
  workkingdir=$(mktemp -d /tmp/da-prj-XXXXXX)
  pushd $workkingdir
  da create python lib -n mypythonlib
  ls ./mypythonlib/mypythonlib/__init__.py
  popd
EOF

