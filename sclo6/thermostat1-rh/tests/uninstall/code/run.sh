#!/bin/bash
yum remove -y thermostat1
ret=$?
yum history -y rollback 1
exit $(($ret+$?))
