#!/bin/bash

all_pass=true

for testcase in Testcase1 Testcase2 Testcase3 Testcase4
do
    testcase_pass=true
    diffdir="${testcase}Diff"
    any_diff=false

    for file1 in "$testcase"/*.1.txt
    do
        file2="${file1/.1.txt/.2.txt}"
        filename=$(basename "$file1")
        base="${filename%.1.txt}"
        outfile="$diffdir/${base}Diff.txt"

        if ! cmp -s "$file1" "$file2"
        then
            any_diff=true

            if [ ! -f "$outfile" ]
            then
                testcase_pass=false
                echo "missing $outfile" >&2
            else
                if ! diff -u \
                    <(diff -u "$file1" "$file2" | tail -n +3) \
                    <(tail -n +3 "$outfile") > /dev/null
                then
                    testcase_pass=false
                    echo "incorrect contents in $outfile" >&2
                fi
            fi
        else
            if [ -f "$outfile" ]
            then
                testcase_pass=false
                echo "unexpected $outfile" >&2
            fi
        fi
    done

    if [ "$any_diff" = true ]
    then
        if [ ! -d "$diffdir" ]
        then
            testcase_pass=false
            echo "missing directory $diffdir" >&2
        fi
    else
        if [ -d "$diffdir" ]
        then
            testcase_pass=false
            echo "unexpected directory $diffdir" >&2
        fi
    fi

    if [ "$testcase_pass" = true ]
    then
        echo "$testcase: PASS"
    else
        echo "$testcase: FAIL"
        all_pass=false
    fi
done

if [ "$all_pass" = true ]
then
    exit 0
else
    exit 1
fi
