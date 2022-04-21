#!/bin/bash

stepName=$1
hdfsPath=$2

#yarn command produces multi column output, we use awk to look at column 2 & compare its value & then print column 1
applicationId=$(yarn application -list -appStates ALL | awk '$2 == "com.deepak.Main" {print $1}')

echo $applicationId

# make a cirectory
mkdir test

# copy all files from any subdirectory of test directory to test1 directory
cp test/*/container* test1/

# using jq to parse json files & extract jobFlowId
id=$(cat /mnt/var/lib/info/job-flow.json | jq -r ".jobFlowId")

# using jq to parse json files & extract Id of the step whose name starts with stepName
stepId = $(aws emr list-steps --cluster-id abcdef | jq -r '.Steps[] | select(.Name | startswith("'"$stepName"'")) | .Id')

# iterate over files of directory & finding lines with text 'Log' & copying those lines to different file
files=(/home/deepak/test/*)
i=0
for f in "${files[@]}"; do
  i=$((i+1))
  awk '/Log/' $f > test/test-$1.json
done

# finds all empty files from directory, prints the name of files & deletes them
find test/ -type f -empty -print -delete
