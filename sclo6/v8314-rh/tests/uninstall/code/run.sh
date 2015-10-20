#!/bin/bash
yum remove -y v8314
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
