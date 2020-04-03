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

# Reads list of scls from stdin and returns only scls that exist on current os_version
filter_scl_for_current_os_version() {
  el_version=${1} ; shift
  while read scl ; do
    # Choose only exact name of the collection; i.e. mysql55, not sclo-mysql55
    grep -e "^[[:space:]]*$scl[[:space:]]*" "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-{rh,sclo}-el$el_version >/dev/null
    [ $? -eq 0 ] && echo "$scl"
  done
}

# accepts one or more options (collection names) and returns list of collections
# that need to be enabled to be able to install the original set
get_depended_collections() {
  el_version=${1} ; shift
  while [ -n "$1" ] ; do
    echo -n "$1 "
    cat "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-dependencies | strip_comments | grep -e "^$1:" | head -n 1 | cut -d':' -f2
    shift
  done | xargs -n1 | sort -u | filter_scl_for_current_os_version "${el_version}" | xargs
}

# get list of all collections
get_collections_list() {
  cat "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-*-el`os_major_version` | strip_comments | cut -d' ' -f1
}

# get list of all collections that are supported
get_supported_collections_list() {
  cat "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-*-el* |  strip_comments | grep -v -e EOL | cut -d' ' -f1 | sort -u
}

# get list of all collections that are NOT supported
get_unsupported_collections_list() {
  cat "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-*-el* |  strip_comments | grep -e EOL | cut -d' ' -f1 | sort -u
}

# returns list of el versions that the collections is available on, formatted as yaml in-line list
get_supported_collections_array() {
  local out=''
  for el in `get_collections_releases "${1}"` ; do
    [ -n "${out}" ] && out="${out}, "
    out="${out}${el}"
  done
  echo "[ ${out} ]"
}

# returns list of el versions that the collections is available on
get_collections_releases() {
  for el in 6 7 ; do
    if grep -qe "^${1}" "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-*-el${el} ; then
      echo -n "$el "
    fi
  done
}

# returns `rh` or `sclo` as output or exits if collections does not exists in the list
# takes two possitional arguments:
# * collection name
# * el_version (6, 7, ...)
get_scl_namespace() {
  local el_version=${2-`os_major_version`}
  local namespace
  for namespace in rh sclo ; do
    # Choose only exact name of the collection; i.e. mysql55, not sclo-mysql55
    grep -e "^[[:space:]]*$1[[:space:]]*" "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-$namespace-el$el_version >/dev/null
    [ $? -eq 0 ] && echo "$namespace" && return 0
  done
  echo "ERROR: collection ${1} not found in PackageLists/collections-list-{rh,sclo}-el$el_version" >&2
  return 1
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

get_public_ip() {
  local hostnames=$(hostname -I)
  local public_ip=''
  local found_ip
  for guess_exp in '127\.0\.0\.1' '192\.168\.[0-9\.]*' '172\.[0-9\.]*' \
                   '10\.[0-9\.]*' '[0-9\.]*' ; do
    found_ip=$(echo "${hostnames}" | grep -oe "${guess_exp}")
    if [ -n "${found_ip}" ] ; then
      hostnames=$(echo "${hostnames}" | sed -e "s/${found_ip}//")
      public_ip="${found_ip}"
    fi
  done
  if [ -z "${public_ip}" ] ; then
    echo "ERROR: public IP could not be guessed."
    return 1
  fi
  echo "${public_ip}"
}

get_collection_name() {
  local -r collection_dir="${1:-$(dirname "${BASH_SOURCE[0]}")}"; shift
  basename "$(readlink -f "$collection_dir")" | sed 's/-\(sclo\|rh\)$//'
}

# Assemble collection parameters into canonical repository name
repo_name() {
  local -r repotype="$1"; shift
  local -r collection="$1"; shift
  local -r el_version="$1"; shift
  local -r arch="${1:-x86_64}"; shift

  local -r namespace="$(get_scl_namespace "$collection" "$el_version")"

  echo "sclo${el_version}-${collection}-${namespace}-${repotype}"
}

# Determine appropriate base URL from collection parameters
repo_baseurl() {
  local -r repotype="$1"
  local -r collection="$2"
  local -r el_version="$3"
  local -r arch="${4:-x86_64}"

  local -r namespace="$(get_scl_namespace "$collection" "$el_version")"
  local -r reponame="$(repo_name "$@")"

  case "$repotype" in
    mirror)
      echo "http://mirror.centos.org/centos-${el_version}/${el_version}/sclo/x86_64/${namespace}/" ;;
    buildlogs)
      echo "http://buildlogs.centos.org/centos/${el_version}/sclo/x86_64/${namespace}/" ;;
    none)
      ;;
    *)
      echo "file:///tmp/local-repos/${reponame}/${arch}/" ;;
  esac
}

# Download tagged packages to local directory and create a repo
# The arguments are the same as for repo_name() and repo_baseurl()
make_local_repo() {
  test "${#@}" -ge 4 || {
    echo "Not enough arguments for make_local_repo: ${#@}" >&2; exit 1
  }

  local -r basearch="$4"
  local -r tag="$(repo_name "$@")"
  local -r baseurl="$(repo_baseurl "$@")"
  local -r root_dir="${baseurl##file://}"

  mkdir -p "${root_dir}" && pushd "${_}" >/dev/null 2>&1 || return

  cbs list-tagged --quiet --latest "${tag}" \
    | awk '{print $1;}' \
    | xargs -P5 -n1 -- cbs download-build --quiet --arch=noarch --arch="${basearch}" \
    || {
      echo "ERROR: Cannot download builds from ${tag}" >&2
      return 1
    }

  createrepo_c --quiet --database "${PWD}" || {
    echo "ERROR: Cannot create local metadata" >&2
    return 1
  }

  popd >/dev/null 2>&1 || return
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
    export YUM_OPTS=--nogpgcheck
  else
    repofile=/etc/yum.repos.d/${REPOFILE-sclo-ci.repo}
    collection="$1"
    el_version="${2-`os_major_version`}"
    basearch="${3:-$(uname -i|grep -v unknown||uname -m)}"

    rm -f "$repofile" ; touch "$repofile"
    for c in $(get_depended_collections "$el_version" "$collection") ; do
      local -a argv=("$repotype" "$c" "$el_version" "$basearch")
      local reponame; reponame="$(repo_name "${argv[@]}")"

      cat >> "$repofile" <<- EOM
[${reponame}]
name=${reponame}
baseurl=$(repo_baseurl "${argv[@]}")
gpgcheck=0
enabled=1

EOM
    done
  fi
}

# vim: set ts=2 sw=2 tw=0 :
