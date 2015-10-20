#!/bin/bash
yum remove -y rh-mongodb26
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
