#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

HAPLIBPATH="${LOCALSTATE_DIR}/lib/haproxy"

retval=0

while read path se_context ; do
  if ! ls -ldZ "${path}" | grep -q "${se_context}" ; then
    echo "File ${path} has wrong context, ${se_context} expected." >&2
    ls -ldZ "${path}"
    retval=1
  fi
done <<< "${HAPLIBPATH} haproxy_var_lib_t
${PREFIX}/sbin/haproxy haproxy_exec_t
/usr/lib/systemd/system/${SYSTEMD_UNIT} haproxy_unit_file_t"

exit $retval

