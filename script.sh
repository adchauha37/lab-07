#!/bin/bash

for testcase in Testcase1 Testcase2 Testcase3 Testcase4
do
    diffdir="${testcase}Diff"

    rm -rf "$diffdir"

    for file1 in "$testcase"/*.1.txt
    do
        file2="${file1/.1.txt/.2.txt}"

        if ! cmp -s "$file1" "$file2"
        then
            mkdir -p "$diffdir"

            filename=$(basename "$file1")
            basename_no_version="${filename%.1.txt}"

            diff -u "$file1" "$file2" > "$diffdir/${basename_no_version}Diff.txt"
        fi
    done
done
