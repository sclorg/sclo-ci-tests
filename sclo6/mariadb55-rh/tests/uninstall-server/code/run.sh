#!/bin/bash
yum remove -y mariadb55
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
