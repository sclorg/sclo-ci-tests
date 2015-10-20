#!/bin/bash
yum remove -y php55
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
