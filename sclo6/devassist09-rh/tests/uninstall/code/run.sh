#!/bin/bash
yum remove -y devassist09
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
