#!/bin/bash
yum remove -y nodejs010
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
