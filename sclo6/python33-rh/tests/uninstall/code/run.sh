#!/bin/bash
yum remove -y python33
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
