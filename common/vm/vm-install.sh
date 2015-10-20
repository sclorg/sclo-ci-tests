#!/bin/bash

#defined constants
repos_path=http://cbs.centos.org/repos/
default_size=12


function existsParam
{
            if test $2 -le 1; then
                echo "No $1 specified"
                exit 1
            fi
}

function usage
{
    echo "Usage:"
    echo "  vm-install.sh -t|--tree TREE"
    echo "                -v|--volume VOLUME"
    echo "                -n|--name NAME"
    echo "                -r|--repoprefix REPO_PREFIX"
    echo "                [-s|--size SIZE]"
}

function user_int
{
    virsh --connect=qemu:///system destroy "$name" 2>/dev/null
    virsh --connect=qemu:///system undefine "$name" 2>/dev/null
    virsh --connect=qemu:///system vol-delete \
        --pool $(basename $(pwd)) "${name}.qcow2" 2>/dev/null
    exit 10
}

trap user_int INT

while test $# -gt 0
do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;

        -s|--size)
            existsParam $1 $#
            shift
            if [ "$1" -le "0" ] 2>/dev/null ; then
                echo "Invalid size specified"
                exit 1
            fi
            size=$1
            shift
            ;;

        -t|--tree)
            existsParam $1 $#
            shift
            tree=$1
            shift
            ;;

        -v|--volume)
            existsParam $1 $#
            shift
            volume=$1
            shift
            ;;

        -r|--repoprefix)
            existsParam $1 $#
            shift
            repoprefix=$1
            if [ "$repoprefix" != "$(echo $repoprefix|egrep '^[a-zA-Z0-9_-]*$')" ]
            then
                echo "Invalid repoprefix given. It must match: ^[a-zA-Z0-9_-]*$"
                exit 1
            fi

            shift
            ;;

        -n|--name)
            existsParam $1 $#
            shift
            name=$1
            shift
            ;;
        *)
            echo -e "Invalid parameter: $1\n"
            usage
            exit 1
            ;;
    esac
done

#set defualt size of image (in GB)
size=${size-$default_size}


# check if all necessary parametres are defined
for i in name size tree volume repoprefix
do
    echo $i: ${!i}
    if [ -z ${!i} ]
    then
        echo "$i was not defined"
        exit 1
    fi
done

#
# Generate repositories
#

repos_html=$(wget -qO- $repos_path)
if [ $? -ne 0 ]
then
    echo "Not possible to download the list of repositories"
    exit 1
fi

repo_names=$(echo "$repos_html" \
            |html2text \
            |grep '\[\[DIR\]\]' \
            |grep -v 'Parent_Directory' \
            |awk '{print $2}' \
            |grep 'candidate/$' \
            |grep "^$repoprefix-" \
            |tr -d '/')

tempdir_path=$(mktemp -d)
echo "tempdir_path: $tempdir_path"

for repo in $repo_names
do
    repo_body="[$repo]\n"
    repo_body+="name=$repo\n"
    repo_body+="failovermethod=priority\n"
    repo_body+="baseurl=$repos_path/$repo/\$basearch/os/\n"
    repo_body+="enabled=1\n"
    repo_body+="gpgcheck=0\n"
    repo_body+="skip_if_unavailable=False\n"

    echo -e "$repo_body" > "$tempdir_path/$repo"".repo"
done

#
# Create virtual machine
#

virt-install --connect=qemu:///system \
    --network=bridge:virbr0 \
    --initrd-inject="$(dirname $0)/minimal-install.ks" \
    --extra-args="ks=file:/minimal-install.ks \
      console=tty0 console=ttyS0,115200" \
    --name="$name" \
    --disk "${volume}/${name}.qcow2,size=${size},format=qcow2,cache=none" \
    --ram 2048 \
    --vcpus=4 \
    --check-cpu \
    --accelerate \
    --hvm \
    --location="$tree" \
    --nographics  \
    --noautoconsole \
    --wait -1

if [ "$?" -ne "0" ]
then
    echo "Not possible to create virtual machnine"
    exit 1
fi

#
# Get ip of the virtual machine
#

#ip=$(arp -e | grep "`virsh --connect=qemu:///system dumpxml  $name | grep "mac address"|sed "s/.*'\(.*\)'.*/\1/g"`" | \
#      awk '{ printf  $1}')

ip=$(arp -e |grep $(virsh --connect=qemu:///system  domiflist "$name" |grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})")  |grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")

echo "IP: $ip"

#
# Copy repositories
#


# Wait for the clkient too boot up and start sshd
while true
do
    if sshpass -p 'redhat' ssh -q -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no root@"$ip" true
    then
        break
    fi
    sleep 2
done

# copy generated repositories to the client
sshpass -p 'redhat' scp -q -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no $(find "$tempdir_path/" -mindepth 1) \
        root@"$ip":/etc/yum.repos.d/

# delete generated repositories from the host
rm -rf "$tempdir_path"

exit 0

