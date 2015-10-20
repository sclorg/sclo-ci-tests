#!/bin/bash
yum remove -y postgresql92
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
