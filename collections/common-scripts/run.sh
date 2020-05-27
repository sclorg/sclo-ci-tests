#!/bin/bash

# Caution: This is common script that is shared by more SCLS.
# If you need to do changes related to this particular collection,
# create a copy of this file instead of symlink.

THISDIR=$(dirname ${BASH_SOURCE[0]})
source ${THISDIR}/../../common/functions.sh

usage() {
    echo "Usage: `basename $0` [ -h | --help ] [ repo ]"
    echo
    echo "This script runs all scripts for particular collection. Collection is determined from the name of the parent directory."
    echo
    echo "Options:"
    echo "  -h, --help    Show this help."
    echo "  repo          Which packages to install. It can be one of candidate, testing, mirror, none. Default none."
}

# parsing command-line args
REPOTYPE=none
while [ -n "$1" ] ; do
    case "$1" in
        -h|--help) usage ; exit 0 ;;
        none) REPOTYPE=none ;;
        candidate) REPOTYPE=candidate ;;
        testing) REPOTYPE=testing ;;
        buildlogs) REPOTYPE=buildlogs ;;
        release) REPOTYPE=release ;;
        mirror) REPOTYPE=mirror ;;
        *) usage ; exit 1 ;;
    esac
    shift
done
if [ "$REPOTYPE" == none ] ; then
    export SKIP_REPO_CREATE=1
fi
export REPOTYPE

out=${out-/dev/stdout}

stPass="[PASSED]"
stFail="[FAILED]"

passed=0
failed=0

readonly scl_name="$(get_collection_name "$(basename "$(readlink -f "$THISDIR")")")"
readonly scl_el="$(os_major_version)"
readonly scl_basearch="$(uname -i|grep -v unknown||uname -m)"

resDirAll=$(mktemp -d /tmp/sclo-results-XXXXXX)

case "$REPOTYPE" in
    candidate|testing|release)
        echo "Install necessary extra packages"
        yum -y --quiet install centos-packager || exit
        echo "Making local repositories for $REPOTYPE ..."
        for collection in $(get_depended_collections "$scl_el" "$scl_name"); do
            make_local_repo "$REPOTYPE" "$collection" "$scl_el" "$scl_basearch"
        done
    ;;
esac

echo "Listing source packages for current ${scl_name} ..."

readonly -a rq_params=(
    '--disablerepo=*'
    "--repofrompath=${scl_name},$(repo_baseurl "$REPOTYPE" "$scl_name" "$scl_el")"
    "--enablerepo=${scl_name}"
    '--all'
    '--source'
)
repoquery "${rq_params[@]}" 2>/dev/null | sort | uniq >"$resDirAll/source-packages.txt"

echo "Running tests for ${scl_name} ..."

for tst in $(cat ${THISDIR}/enabled_tests|grep -v '^#')
do
    resDir="$resDirAll/$tst"
    mkdir -p "$resDir"

    ${THISDIR}/$tst/run.sh \
            2> >(tee "$resDir/err" | sed 's/^/\t/' >$out) \
            > >(tee "$resDir/out" | sed 's/^/\t/' >$out)
    retcode=$?

    echo "$retcode" >"$resDir/retcode"

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


    echo -e "$state\t$tst" | tee -a $resDirAll/tests.log


    if [ "$state" = "$stPass" ]
    then
        passed=$(($passed+1))

    else
        failed=$(($failed+1))
        failed_tests="$failed_tests $tst"
    fi
done

echo
echo "Test results summary:"
cat $resDirAll/tests.log

echo -e "\n$passed tests passed, $failed tests failed."

if [ "0$failed" -ne 0 ]
then
    echo -e "\nFailed tests:"
    for i in "$failed_tests"
    do
        echo -e "\t $i"
    done

    echo "Logs are stored in $resDirAll"
    echo "NOT ALL TESTS PASSED SUCCESSFULLY"

    # If some test went wrong return 10
    exit 10
fi

