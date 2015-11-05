#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../common/functions.sh

if ! [ -v SSH_HOST ] ; then echo "Missing SSH_HOST variable, set it" ; exit 1 ; fi
if ! [ -v SSH_PASS ] ; then echo "Missing SSH_PASS variable, set it" ; exit 1 ; fi
SSH_USER=${SSH_USER-root}

function sshwp
{
    sshpass -p "${SSH_PASS}" ssh -q -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no "${SSH_USER}@${SSH_HOST}" "${@}"
}

rel_path=$(readlink -f $THISDIR | sed -e "s|^`project_root`/||")
git_url=$(git config --get remote.origin.url || echo https://github.com/sclorg/sclo-ci-tests.git)

echo "Using host $SSH_HOST, user $SSH_USER."
sshwp "
repo=\$(mktemp -d /tmp/sclo-ci-XXXXXX)
git clone $git_url \$repo/repo
cd \$repo/repo/$rel_path
./run.sh
"


