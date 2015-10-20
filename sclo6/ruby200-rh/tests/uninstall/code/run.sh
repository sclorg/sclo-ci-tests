#!/bin/bash
yum remove -y ruby200
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
