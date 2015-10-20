#!/bin/bash
yum remove -y ror40
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
