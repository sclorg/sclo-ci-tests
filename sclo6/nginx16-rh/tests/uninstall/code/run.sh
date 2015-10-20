#!/bin/bash
yum remove -y nginx16
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
