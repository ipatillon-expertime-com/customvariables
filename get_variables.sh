#!/bin/bash

if [ $# -ne 2 ]
  then
    echo "Bad arguments supplied !"
    echo "Command : get_variables.sh -e [--environment] prd|uat|dev"
    exit 2
fi

export evt=""
export dstFile="modules/global/main.tf"

while  [ -n "$1" ]
do
    case "$1" in
        --environment) export evt=$2;;
        -e) export export evt=$2;;
    esac
    shift
done

if [ "$evt" == "" ]
  then
    echo "Bad arguments supplied !"
    echo "Command : get_variables.sh -e [--environment] prd|uat|dev"
    exit 2
fi

echo "Working in the $evt environment"
export srcFile="environments/$evt/resources.csv"

if [ -f $srcFile ]
then
    cp templates/sample.tf.source $dstFile
else
    echo "Source resource file not found ! : $srcFile"
    exit 2
fi

IFS=","
while read -r -a fields
do
    export f0=$(echo "${fields[0]}" | sed -e 's/^[ \t]*//;s/[ \t]*$//')
    export f1=$(echo "${fields[1]}" | sed -e 's/^[ \t]*//;s/[ \t]*$//')
    if [ $f0 != "" -a $f0 != "local_name" ]
      then
        sed -i "s/DEFAULT$f0/$f1/" $dstFile
    fi
done < environments/$evt/resources.csv

export notDone=$(grep 'DEFAULT' $dstFile | wc -l)

if [ $notDone != 0 ]
  then
    echo "Some Variables are missing from CSV !"
    export outText=$(grep 'DEFAULT' $dstFile)
    echo "$outText"
fi
