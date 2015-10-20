#/bin/bash

test_list_file="enabled_tests"
password=redhat

#================================
stPass="[PASSED]"
stFail="[FAILED]"

function sshwp
{
    sshpass -p "$password" ssh -q -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no "${@}"
}

function scpwp
{
    sshpass -p "$password" scp -q -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no "${@}"
}


if [ ! -f "$test_list_file" ]
then
    echo "$0: $test_list_file file missing"
    exit 1
fi

test_list=$(cat "$test_list_file")


if  [ -f machine.conf ]
then
    virt_name=$(cat machine.conf|grep "^name="|sed -r 's/^[^=]*=//' |tail -n 1)
fi

while [ $#  -gt 0 ]
do
    case "$1" in
        -V|--verbose)
            out='/dev/stdout'
            shift
            ;;
        *)
            if [ $# -eq 1 ]
            then
                virt_name=$1
            else
                echo "$0: Invalid parameter: $1"
                exit 1
            fi
            shift
            ;;
    esac

done

if [ -z $virt_name ]
then
    echo "$0: Virtual machine name not given"
    exit 1
fi


out=${out-/dev/null}

# Get Mac

virsh list 2>/dev/null >/dev/null
if [ $? -eq 1 ]
then
    sudo='sudo '
    echo "Connection to virtual machine requires root permissions:"
fi

if ! mac=$($sudo virsh --connect=qemu:///system  domiflist "$virt_name" 2>/dev/null \
            |grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})")
then
    echo "$0: Failed to find virtual machine: $virt_name"
    exit 3
fi


# Get IP
if ! ip=$(arp -e |grep  $mac  \
            |grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")
then
    echo "$0: Failed to get ip of the client in arp table"
    exit 4
fi

rm -rf results
mkdir results

#create a directory for tests on client
if ! testdir=$(sshwp root@"$ip" "mktemp -d")
then
    echo "$0: Unable to create directory for tests on the client"
    exit 2
fi


passed=0
failed=0


#run tests
for tst in $(echo "$test_list"|grep -v '^#')
do
    resDir="results/$(basename $tst)"
    mkdir "$resDir"
    if [ "$out" != "/dev/null" ]
    then
        echo -e "\nRunning test: $tst:" | tee -a results/tests.log

    else
        printf "$tst:\t" | tee -a results/tests.log
    fi

    #copy test to the client
    if ! scpwp -r "$tst/code" root@"$ip:$testdir"
    then
        echo "$0: $tst: not possible to copy the test to the client"
        failed=$(($failed+1))
        failed_tests="$failed_tests $tst"
        continue
    fi


    #run the test
    sshwp root@"$ip" \
        "pushd $testdir/code >/dev/null; ./run.sh" \
            2> >(tee "$resDir/err" | sed 's/^/\t/' >$out) \
            > >(tee "$resDir/out" | sed 's/^/\t/' >$out)
    retcode=$?

    echo "$retcode" >"$resDir/retcode"

    #if the speciffic retcode was NOT defined and 255 is returned
    if ! [ -f "$tst/retcode" ] &  [ "$retcode" -eq  "255" ]
    then
        echo "$0: $tst: Unable to connect to the client via ssh"
        failed=$(($failed+1))
        failed_tests="$failed_tests $tst"
        continue
    fi

    state=$stFail

    # check retcode
    if [ -f "$tst/retcode" ]
    then
        # if defined explicitly
        if echo "$retcode" | diff - "$tst/retcode" >/dev/null
        then
            state=$stPass
        else
            state=$stFail
        fi
    else
        #if not defined explicitly then 0 is expected
        if [ "$retcode" -eq "0" ]
        then
            state=$stPass
        else
            state=$stFail
        fi
    fi

    # if defined expected stdout, compare it with acctual stdout
    if [ -f "$tst/out" ] && [ "$state" != "$stFail" ]
    then
        if diff "$resDir/out" "$tst/out" >/dev/null
        then
            state=$stPass
        else
            state=$stFail
        fi
    fi

    # if defined expected stderr, compare it with acctual stderr
    if [ -f "$tst/err" ] && [ "$state" != "$stFail" ]
    then
        if diff "$resDir/err" "$tst/err" >/dev/null
        then
            state=$stPass
        else
            state=$stFail
        fi
    fi


    if [ "$out" != "/dev/null" ]
    then
        echo -e "$tst:\t$state" | tee -a results/tests.log
    else
        echo "$state" | tee -a results/tests.log
    fi


    if [ "$state" = "$stPass" ]
    then
        passed=$(($passed+1))

    else
        failed=$(($failed+1))
        failed_tests="$failed_tests $tst"
    fi
done

#remove the test dir from the client
sshwp  root@"$ip" "rm -rf $testdir"

echo -e "\n$passed tests passed, $failed tests failed."

if [ $failed -ne 0 ]
then
    echo -e "\nFailed tests:"
    for i in "$failed_tests"
    do
        echo -e "\t $i"
    done

    echo "NOT ALL TESTS PASSED SUCCESSFULLY"

    # If some test went wrong return 10
    exit 10
fi

# all tests went ok, return 0
exit 0
