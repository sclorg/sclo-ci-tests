#!/bin/bash
yum remove -y mongodb24
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
