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

for c in `get_depended_collections $collection` ; do
  echo "$namespace"
  namespace=$(get_scl_namespace "$c" "$el_version")
  cat >> "$repofile" <<- EOM
[sclo${el_version}-${c}-${namespace}-candidate]
name=sclo${el_version}-${c}-${namespace}-candidate
baseurl=http://cbs.centos.org/repos/sclo${el_version}-${c}-${namespace}-candidate/${arch}/os/
gpgcheck=0
enabled=1

EOM
done

yum -y update

yum -y install "$collection" || retval=1

rm -f "$repofile"
exit $retval

