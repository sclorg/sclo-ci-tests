#!/bin/bash
yum remove -y rh-perl520
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
