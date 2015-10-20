#!/bin/bash
yum remove -y php54
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
