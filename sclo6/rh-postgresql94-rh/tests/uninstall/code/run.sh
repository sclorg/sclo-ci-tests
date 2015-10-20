#!/bin/bash
yum remove -y rh-postgresql94
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
