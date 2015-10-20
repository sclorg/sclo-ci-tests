#!/bin/bash
yum remove -y nginx14
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
