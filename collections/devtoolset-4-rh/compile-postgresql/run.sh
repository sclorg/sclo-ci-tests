#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

# make sure we don't use system gcc
#yum -y remove gcc || :
# install dependencies for compilation process
yum -y install wget
scl enable $INSTALL_SCLS - <<"EOF"
  set -ex
  workkingdir=$(mktemp -d /tmp/da-prj-XXXXXX)
  pushd $workkingdir
  wget https://ftp.postgresql.org/pub/source/v9.4.4/postgresql-9.4.4.tar.bz2
  tar -xf postgresql-9.4.4.tar.bz2
  cd postgresql-9.4.4
  ./configure --without-readline --without-zlib
  make
  gccver=$(strings -a ./src/backend/postgres | grep -oe "compiled by.*GCC) \([0-9]*\.[0-9]*\.\)" | sed -e 's/.*[[:space:]]//')
  [ "${gccver}" != "5.2." ] && echo "Wrong GCC version found in postgres binary: ${gccver}" && exit 1
  popd
EOF

