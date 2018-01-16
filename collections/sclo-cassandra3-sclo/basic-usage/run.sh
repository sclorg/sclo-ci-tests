#!/bin/bash

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../../common/functions.sh
source ${THISDIR}/../include.sh

source scl_source enable ${ENABLE_SCLS}

set -xe

cqlsh -e "CREATE KEYSPACE IF NOT EXISTS k1 WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}  AND durable_writes = true; USE K1; CREATE TABLE IF NOT EXISTS person (id text, name text, surname text, email text, PRIMARY KEY (id)); INSERT INTO person (id, name, surname, email) VALUES ('003', 'Harry', 'Potter', 'harry@example.com');"

out=$(
cqlsh -e "USE k1; SELECT count(*) FROM person WHERE id = '003'";
)
out=$(echo "$out"|head -4|tail -1|awk '{$1=$1};1')

echo $out

[ "$out" == "1" ]

