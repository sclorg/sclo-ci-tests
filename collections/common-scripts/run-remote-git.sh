#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../common/functions.sh

# if SSH_HOST not set, get it from VM_NAME variable
if ! [ -v SSH_HOST ] ; then
  if ! [ -v VM_NAME ] ; then
    echo "Missing SSH_HOST and VM_NAME variable, set at least one of them."
    exit 1
  fi

  virsh list 2>/dev/null >/dev/null
  if [ $? -eq 1 ] ; then
    sudo='sudo '
    echo "Connection to virtual machine requires root permissions:"
  fi

  if ! mac=$($sudo virsh --connect=qemu:///system  domiflist "$VM_NAME" 2>/dev/null \
            |grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})") ; then
    echo "$0: Failed to find virtual machine: $VM_NAME"
    exit 3
  fi

  # Get IP
  if ! SSH_HOST=$(arp -e |grep -e "$mac"  \
            |grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}") ; then
    echo "$0: Failed to get ip of the client in arp table"
    exit 4
  fi
  echo Found $SSH_HOST
fi

if ! [ -v SSH_PASS ] ; then
  echo "Missing SSH_PASS variable, set it"
  exit 1
fi

SSH_USER=${SSH_USER-root}

function sshwp
{
    sshpass -p "${SSH_PASS}" ssh -q -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no "${SSH_USER}@${SSH_HOST}" "${@}"
}

rel_path=$(readlink -f $THISDIR | sed -e "s|^`project_root`/||")
git_url=$(git config --get remote.origin.url || echo https://github.com/sclorg/sclo-ci-tests.git)
git_branch=$(git name-rev --name-only HEAD || echo master)

echo "Using host $SSH_HOST, user $SSH_USER."
sshwp "
repo=\$(mktemp -d /tmp/sclo-ci-XXXXXX)
git clone -b $git_branch $git_url \$repo/repo
cd \$repo/repo/$rel_path
./run.sh
"

