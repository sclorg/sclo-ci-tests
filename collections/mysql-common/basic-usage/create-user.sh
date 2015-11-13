#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh

set -xe

service $SERVICE_NAME restart

mysql -u root <<'EOF'
CREATE DATABASE IF NOT EXISTS db1;
GRANT USAGE ON *.* TO 'valeria'@'localhost';
DROP USER 'valeria'@'localhost';
FLUSH PRIVILEGES;
CREATE USER 'valeria'@'localhost' IDENTIFIED BY 'secretpass';
GRANT ALL ON db1.* TO 'valeria'@'localhost';
FLUSH PRIVILEGES;
EOF

mysql -u valeria -psecretpass db1 <<'EOF'
DROP TABLE IF EXISTS test_table;
CREATE TABLE test_table (id MEDIUMINT NOT NULL AUTO_INCREMENT, fakedata varchar(20), fakevalue INT, PRIMARY KEY (id));
INSERT INTO test_table (fakedata, fakevalue) VALUES ('tramtarada', 4);
INSERT INTO test_table (fakedata, fakevalue) VALUES ('tramtaraa', 5);
EOF

out=$(
mysql -u valeria -psecretpass db1 <<'EOF'
SELECT COUNT(*) as count FROM test_table WHERE fakevalue=4 \G
EOF
)
out=$(echo "$out"|tail -n 1)

[ "$out" == "count: 1" ]

