#!/bin/bash

stepName=$1
hdfsPath=$2

#yarn command produces multi column output, we use awk to look at column 2 & compare its value & then print column 1
applicationId=$(yarn application -list -appStates ALL | awk '$2 == "com.deepak.Main" {print $1}')

echo $applicationId
