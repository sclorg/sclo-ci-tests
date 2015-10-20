#!/bin/bash
yum remove -y httpd24
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
