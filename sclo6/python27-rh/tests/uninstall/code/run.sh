#!/bin/bash
yum remove -y python27
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
