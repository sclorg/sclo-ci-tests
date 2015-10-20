#!/bin/bash
yum remove -y git19
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
