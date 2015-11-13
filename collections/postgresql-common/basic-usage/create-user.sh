#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

[ -z "${PGDATA}" ] && exit_fail "Environment variable PGDATA must be set"

service $SERVICE_NAME restart

su - postgres <<'EOF'
source scl_source enable $ENABLED_SCLS
psql -c "CREATE ROLE testuser ENCRYPTED PASSWORD 'secretpass' LOGIN;"
createdb testdb --owner testuser;
EOF

echo "local all testuser md5" > ${PGDATA}/data/pg_hba.conf
service $SERVICE_NAME restart

