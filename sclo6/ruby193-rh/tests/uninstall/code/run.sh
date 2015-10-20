#!/bin/bash
yum remove -y ruby193
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
