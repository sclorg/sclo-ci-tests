#!/bin/bash

out=$(scl enable sclo-cassandra3 rh-java-common rh-maven33 'cassandra -v')
retcode=$?

echo "$out"

exit $retcode
