#!/bin/bash

# Setup a vagrant infra we can use
# ToDo: check we are on centos7
# ToDo: check we are being run as root

set -x

source common.sh

if [ $# -lt 2 ] ; then
  echo "Usage: `basename $0` <collection> <el_version{6|7|..}>" >&2
  exit 1
fi

collection="$1"
el_version="$2"
arch=${3-x86_64}
retval=0

repofile=/etc/yum.repos.d/sclo-ci-test.repo
rm -f "$repofile"
touch "$repofile"

generate_repo_file "$collection" "$el_version" "$arch" >"$repofile"

yum -y update
yum -y install "$collection" || retval=1

rm -f "$repofile"

exit $retval

