#!/bin/bash
yum remove -y rh-php56
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
