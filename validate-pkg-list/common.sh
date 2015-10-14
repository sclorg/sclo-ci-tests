# Some common functions for scripts in this directory

# removes comments and empty lines from a file
strip_comments() {
  cat | sed -e 's:#.*$::g' -e '/^[[:space:]]*$/d'
}

# accepts one option (collection) and returns list of collections that need to be enabled to be able to install this one
get_depended_collections() {
  echo -n "$1 "
  cat ../PackageLists/collections-dependencies | strip_comments | grep -e "^$1:" | head -n 1 | cut -d':' -f2
}

# returns `rh` or `sclo` as output or exits if collections does not exists in the list
# takes two possitional arguments:
# * collection name
# * el_version (6, 7, ...)
get_scl_namespace() {
  for namespace in rh sclo ; do
    grep -e "^[[:space:]]*$1[[:space:]]*$" ../PackageLists/collections-list-$namespace-el$2 >/dev/null
    [ $? -eq 0 ] && echo "$namespace" && return 0
  done
  return 1
}


