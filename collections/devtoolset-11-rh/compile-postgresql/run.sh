#!/bin/bash

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
  ./configure --without-readline --without-zlib
  make
  gccver=$(strings -a ./src/backend/postgres | grep -oe "compiled by.*GCC) \([0-9]*\.\)" | sed -e 's/.*[[:space:]]//')
  [ "${gccver}" != "11." ] && echo "Wrong GCC version found in postgres binary: ${gccver}" && exit 1
  popd
EOF

