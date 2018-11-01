#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

scl enable $INSTALL_SCLS - <<"EOF"
  set -ex
  workkingdir=$(mktemp -d /tmp/da-prj-XXXXXX)
  pushd $workkingdir
  git clone https://github.com/sclorg/sclo-ci-tests.git
  cd sclo-ci-tests
  newbranch=new-branch$$
  git checkout -b $newbranch
  touch somenewfile
  git add somenewfile
  git commit -m "Adding a new file"
  git checkout master
  git merge $newbranch
  [[ "$(git diff HEAD~1 --summary)" =~  "create mode 100644 somenewfile" ]] || exit 1
  popd
EOF

