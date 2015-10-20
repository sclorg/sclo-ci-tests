#!/bin/bash
yum remove -y rh-passenger40
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
