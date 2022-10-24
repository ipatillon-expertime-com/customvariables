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

# read from CSV file and TRIM the parts separated by ","
# do the replace in the terraform file
# f0 : Terraform local name
# f1 : Azure resource name

# separator
IFS=","

# read the fields
while read -r -a fields
do
    # TRIM first field
    export f0=$(echo "${fields[0]}" | sed -e 's/^[ \t]*//;s/[ \t]*$//')
    # TRIM second field
    export f1=$(echo "${fields[1]}" | sed -e 's/^[ \t]*//;s/[ \t]*$//')
    
    # if we are not first line and getting a field name
    if [ $f0 != "" -a $f0 != "local_name" ]
      then
        # change Azure resource Name into dstFile
        sed -i "s/DEFAULT$f0/$f1/" $dstFile
    fi
# read from the CSV file
done < environments/$evt/resources.csv

# search if there still some DEFAULT name in dstFile
export notDone=$(grep 'DEFAULT' $dstFile | wc -l)

# if there are : signal them
if [ $notDone != 0 ]
  then
    echo "Some Variables are missing from CSV !"
    export outText=$(grep 'DEFAULT' $dstFile)
    echo "$outText"
fi
