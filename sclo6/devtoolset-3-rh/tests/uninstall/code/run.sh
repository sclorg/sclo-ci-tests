#!/bin/bash
yum remove -y devtoolset-3
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
