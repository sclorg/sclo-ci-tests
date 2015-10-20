#!/bin/bash
yum remove -y rh-ruby22
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
