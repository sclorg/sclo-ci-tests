#!/bin/sh

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/common/functions.sh

test_released_repo() {
  collection="$1"

  yum -y install centos-release-scl >/dev/null
  yum -y remove \*-scldevel >/dev/null
  yum -y install ${collection}\* >/dev/null

  keyid=$(gpg --list-packets /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-SCLo | grep -e '^\s*keyid' | awk '{print tolower($NF)}')
  echo "Checking all packages for signing key $keyid:"
  rpm -qa --qf '%{NAME}-%{VERSION}-%{RELEASE} %{SIGPGP:pgpsig}\n' ${collection}\* | awk '{print $1, tolower($NF)}' | while read pkg key ; do
    [ "$keyid" != "$key" ] && echo -n "[FAIL] " || echo -n "[PASS] "
    echo "$pkg has key ID: $key"
  done
}

if [ "$1" == '-h' ] || [ "$1" == '--help' ] ; then
  echo "Usage: `basename $0` [ collection , ...]"
  echo "This script tests whether all packages in the collection are signed."
  echo "If no arguments given, all collections are tested."
  exit 1
fi

for scl in ${@-`get_collections_list`} ; do
  test_released_repo "${scl}"
done


