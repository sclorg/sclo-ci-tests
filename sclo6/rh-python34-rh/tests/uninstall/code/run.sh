#!/bin/bash
yum remove -y rh-python34
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
