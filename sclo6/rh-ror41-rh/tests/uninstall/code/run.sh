#!/bin/bash
yum remove -y rh-ror41
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
