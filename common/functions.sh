# Some common functions for scripts in this directory

# removes comments and empty lines from a file
strip_comments() {
  cat | sed -e 's:#.*$::g' -e '/^[[:space:]]*$/d'
}

# accepts one option (collection) and returns list of collections that need to be enabled to be able to install this one
get_depended_collections() {
  echo -n "$1 "
  cat "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-dependencies | strip_comments | grep -e "^$1:" | head -n 1 | cut -d':' -f2
}

# returns `rh` or `sclo` as output or exits if collections does not exists in the list
# takes two possitional arguments:
# * collection name
# * el_version (6, 7, ...)
get_scl_namespace() {
  for namespace in rh sclo ; do
    grep -e "^[[:space:]]*$1[[:space:]]*$" "`dirname ${BASH_SOURCE[0]}`"/../PackageLists/collections-list-$namespace-el$2 >/dev/null
    [ $? -eq 0 ] && echo "$namespace" && return 0
  done
  return 1
}

# generate a yum repo file for specified collection and write it to stdout
# accepts these possitional arguments:
# * collection
# * el_version (6, 7, ...)
# * arch (x86_64, ppc64, ...)
generate_repo_file() {
  collection="$1"
  el_version="$2"
  arch="$3"
  for c in `get_depended_collections $collection` ; do
    namespace=$(get_scl_namespace "$c" "$el_version")
    cat >> "$repofile" <<- EOM
[sclo${el_version}-${c}-${namespace}-candidate]
name=sclo${el_version}-${c}-${namespace}-candidate
baseurl=http://cbs.centos.org/repos/sclo${el_version}-${c}-${namespace}-candidate/${arch}/os/
gpgcheck=0
enabled=1

EOM
  done
}


