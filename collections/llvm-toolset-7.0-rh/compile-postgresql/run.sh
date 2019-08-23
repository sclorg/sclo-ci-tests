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
install_build_tools
yum -y install 'perl(ExtUtils::MakeMaker)' glibc-devel bison flex gawk 'perl(ExtUtils::Embed)' readline-devel zlib-devel

scl enable $INSTALL_SCLS - <<"EOF"
  set -ex
  workkingdir=$(mktemp -d /tmp/da-prj-XXXXXX)
  pushd $workkingdir
  wget https://ftp.postgresql.org/pub/source/v9.4.4/postgresql-9.4.4.tar.bz2
  tar -xf postgresql-9.4.4.tar.bz2
  cd postgresql-9.4.4
  ./configure --without-readline --without-zlib --with-CC=clang
  CC=clang make
  clangver=$(strings -a ./src/backend/postgres | grep -oe "compiled by.*clang version \([0-9]*\.\)" | sed -e 's/.*[[:space:]]//')
  [ "${clangver}" != "7." ] && echo "Wrong clang version found in postgres binary: ${clangver}" && exit 1
  popd
EOF

