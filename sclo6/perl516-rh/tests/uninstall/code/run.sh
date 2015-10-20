#!/bin/bash
yum remove -y perl516
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
