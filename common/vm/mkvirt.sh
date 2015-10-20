#!/bin/bash

tree=$1

function usage
{
    echo "Usage: mkvirt.sh [-n|--name NAME]"
    echo "                 [-s|--size SIZE]"
    echo "                 [-v|--volume VOLUME]"
    echo "                 [-r|--repoprefix VOLUME]"
    echo "                 tree-url"
    echo
    echo "Program reads machine.conf file containing parametres."
    echo "Patrametres on the command line have the highiest priority."
    echo "Default size is 8(GB), default volume dir is '.'"
}

if ls machine.conf 2> /dev/null > /dev/null
then
    for i in volume_dir name size
    do
        eval $i=$(cat machine.conf|grep "^$i="|sed -r 's/^[^=]*=//' | tail -n 1)
#echo "$i: ${!i}"
    done
fi

if [ "$(basename $0)" = "mkvirt-sclo7.sh" ]
then
    repoprefix=sclo7
else if [ "$(basename $0)" = "mkvirt-sclo6.sh" ]
then
    repoprefix=sclo6
fi
fi


while [ $# -gt 0 ]
do
    case "$1" in
        -n|--name)
            shift
            name=$1
            shift
            ;;

        -v|--volume)
            shift
            volume_dir=$1
            shift
            ;;

        -s|--size)
            shift
            size=$1
            shift
            ;;

        -r|--repoprefix)
            shift
            repoprefix=$1
            shift
            ;;

        -h|--help)
            usage
            exit 0
            ;;

        *)
            if [ $# -eq 1 ]
            then
                tree=$1
            else
                echo "Invalid parameter given: $1"
                usage
                exit 1
            fi
            shift
            ;;
        esac
done

size=${size-8}
volume_dir=${volume_dir-.}

#for i in name volume_dir tree size
#do
#echo $i: ${!i}
#done

if [ -z $repoprefix ]
then
    echo "$0: No repoprefix was defined"
    exit 1
fi

if [ -z $name ]
then
    echo "$0: Name of the virtual machine was not given"
    usage
    exit 1
fi

if [ -z $tree ]
then
    echo "$0: tree was not given"
    usage
    exit 1
fi

# Create virtual machine
$(dirname $(realpath $0))/vm-install.sh \
    -v "$volume_dir" \
    -n "$name" \
    -t "$tree" \
    -r "$repoprefix"

retcode=$?

if [ $retcode -ne 0 ]
then
    if [ $retcode -eq 10 ]
    then
        exit 10
    fi
    echo "$0: problem occured during creation of virtual machine"
    exit 2
fi

#Get IP
ip=$(arp -e |grep $(virsh --connect=qemu:///system  domiflist "$name"|grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})")  |grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")

echo $ip
