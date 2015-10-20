#!/bin/bash
yum remove -y rh-mariadb100
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
