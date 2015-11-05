#!/bin/bash

# Loop through all collections repos and check whether they include all
# packages that are expected

[ -d ./PackageLists ] && rootdir=./
[ -d ../PackageLists ] && rootdir=../
[ -z "$rootdir" ] && echo "Could not find root directory" && exit 1

source $rootdir/common/functions.sh

if [ $# -lt 1 ] ; then
  echo "Usage: `basename $0` <el_version{6|7|..}>" >&2
  exit 1
fi

el_version="$1" ; shift

if [ $# -eq 0 ] ; then
  collections=$(cat $rootdir/PackageLists/collections-*-el"$el_version" | strip_comments)
else
  collections="$@"
fi

# loop through all collections and test all
for collection in $collections ; do
  echo "Checking SCL $collection ..."
  ./run-repo-tests.sh "$collection" "$el_version"
done

