# Some common functions for scripts in this directory

# removes comments and empty lines from a file
strip_comments() {
  cat | sed -e 's:#.*$::g' -e '/^[[:space:]]*$/d'
}

# get major version of the system
os_major_version() {
  [ -n "$OVERRIDE_OS_MAJOR_VERSION" ] && echo $OVERRIDE_OS_MAJOR_VERSION && return
  rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release) | grep -o "^[0-9]*"
}

# accepts one or more options (collection names) and returns list of collections
# that need to be enabled to be able to install the original set
get_depended_collections() {
  while [ -n "$1" ] ; do
    echo -n "$1 "
    cat "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-dependencies | strip_comments | grep -e "^$1:" | head -n 1 | cut -d':' -f2
    shift
  done | xargs -n1 | sort -u | xargs
}

# get list of all collections
get_collections_list() {
  cat "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-*-el`os_major_version` | strip_comments
}

# returns `rh` or `sclo` as output or exits if collections does not exists in the list
# takes two possitional arguments:
# * collection name
# * el_version (6, 7, ...)
get_scl_namespace() {
  el_version=${2-`os_major_version`}
  for namespace in rh sclo ; do
    grep -e "^[[:space:]]*$1[[:space:]]*$" "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-$namespace-el$el_version >/dev/null
    [ $? -eq 0 ] && echo "$namespace" && return 0
  done
  return 1
}

# generate a yum repo file for specified collection and write it to stdout
# accepts these possitional arguments:
# * collection
# * el_version (6, 7, ...), optional
# * arch (x86_64, ppc64, ...), optional
# The following environment variables can be set to change default values:
# * REPOTYPE, if not set, then candidate
# * REPOFILE, if not set, then sclo-ci.repo
# * SKIP_REPO_CREATE, if set to 1, then no repository is created
generate_repo_file() {
  [ "0$SKIP_REPO_CREATE" -eq 1 ] && return
  repotype=${REPOTYPE-candidate}
  if [ "$repotype" == "mirror" ] ; then
    yum -y install centos-release-scl
  elif [ "$repotype" == "buildlogs" ] ; then
    yum -y install centos-release-scl
    yum-config-manager --enable centos-sclo-rh-testing
    yum-config-manager --enable centos-sclo-sclo-testing
  else
    repofile=/etc/yum.repos.d/${REPOFILE-sclo-ci.repo}
    collection="$1"
    el_version="${2-`os_major_version`}"
    arch="${3-\$basearch}"

    rm -f "$repofile" ; touch "$repofile"
    for c in `get_depended_collections $collection` ; do
      namespace=$(get_scl_namespace "$c" "$el_version")
      cat >> "$repofile" <<- EOM
[sclo${el_version}-${c}-${namespace}-$repotype]
name=sclo${el_version}-${c}-${namespace}-$repotype
baseurl=http://cbs.centos.org/repos/sclo${el_version}-${c}-${namespace}-$repotype/${arch}/os/
gpgcheck=0
enabled=1

EOM
    done
  fi
}

project_root() {
  readlink -f $(dirname `dirname ${BASH_SOURCE[0]}`)
}

exit_fail() {
  echo -n "[FAIL] "
  echo $@
  exit 1
}

# install basic tools that are usually needed for building other SW
install_build_tools() {
  yum -y install \
      bash bzip2 coreutils cpio diffutils findutils gawk gcc gcc-c++ grep \
      gzip info make patch redhat-rpm-config rpm-build sed shadow-utils \
      tar unzip util-linux-ng wget which iso-codes
}

