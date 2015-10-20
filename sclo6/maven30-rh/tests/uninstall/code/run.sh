#!/bin/bash
yum remove -y maven30
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
