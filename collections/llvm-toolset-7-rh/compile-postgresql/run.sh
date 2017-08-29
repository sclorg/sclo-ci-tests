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
yum -y install wget bzip2-devel bzip2 coreutils cpio diffutils findutils gawk gcc gcc-c++ grep gzip info make patch redhat-release-server redhat-rpm-config rpm-build sed shadow-utils tar unzip util-linux-ng which iso-codes 'perl(ExtUtils::MakeMaker)' glibc-devel bison flex gawk 'perl(ExtUtils::Embed)' readline-devel zlib-devel

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
  [ "${clangver}" != "4." ] && echo "Wrong clang version found in postgres binary: ${clangver}" && exit 1
  popd
EOF

