#!/bin/bash -x
#
# Installs cicoclient for CentOS CI Duffy access into the workspace
# http://python-cicoclient.readthedocs.org/en/latest/index.html

if [ ! -d cicoclient ]; then
    mkdir cicoclient
    virtualenv cicoclient
fi

source cicoclient/bin/activate

if ! type cico >/dev/null 2>&1; then
    pip install python-cicoclient
fi
