#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

[ -z "${PGDATA}" ] && exit_fail "Environment variable PGDATA must be set"

source scl_source enable ${ENABLE_SCLS}

export PGPASSWORD=secretpass
psql -d testdb -U testuser <<EOF
\x on
CREATE TABLE test_table (id bigserial primary key,fakedata varchar(20),toDelete boolean);
TRUNCATE TABLE test_table;
INSERT INTO test_table (fakedata,toDelete) VALUES ('tramtarada', false);
INSERT INTO test_table (fakedata,toDelete) VALUES ('tramtaraa', true);
EOF

out=$(
psql -d testdb -U testuser <<EOF
\x on
SELECT COUNT(*) FROM test_table WHERE toDelete=false;
EOF
)
out=$(echo "$out"|tail -n 1)

[ "$out" == "count | 1" ]

