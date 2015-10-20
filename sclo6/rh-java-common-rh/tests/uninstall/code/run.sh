#!/bin/bash
yum remove -y rh-java-common
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
