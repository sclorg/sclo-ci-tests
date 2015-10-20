#!/bin/bash
yum remove -y mysql55
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
