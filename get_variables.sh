#!/bin/bash

# echo command line to help
if [ $# -ne 2 ]
  then
    echo "Bad arguments supplied !"
    echo "Command : get_variables.sh -e [--environment] prd|uat|dev"
    exit 2
fi

# init vars (environment and destination_file_name)
export evt=""
export dstFile="modules/global/main.tf"

# check parameters
while  [ -n "$1" ]
do
    case "$1" in
        --environment) export evt=$2;;
        -e) export evt=$2;;
    esac
    shift
done

# if bad parameters
# echo command line to help
if [ "$evt" == "" ]
  then
    echo "Bad arguments supplied !"
    echo "Command : get_variables.sh -e [--environment] prd|uat|dev"
    exit 2
fi

echo "Working in the $evt environment"
export srcFile="environments/$evt/resources.csv"

# test
# if CSV source file exists then copy terraform template
if [ -f $srcFile ]
then
    cp templates/sample.tf.source $dstFile
else
    echo "Source resource file not found ! : $srcFile"
    exit 2
fi

# read from CSV file and TRIM the parts separeted by ","
# do the replace in the terraform file
# f0 : Terraform local name
# f1 : Azure resource name
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

# search if there still some DEFAULT name
export notDone=$(grep 'DEFAULT' $dstFile | wc -l)

# if there are : signal them
if [ $notDone != 0 ]
  then
    echo "Some Variables are missing from CSV !"
    export outText=$(grep 'DEFAULT' $dstFile)
    echo "$outText"
fi
