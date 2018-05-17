#!/bin/bash
# bash downloadMarkup.sh <options>
# Authors: Le Hou, Joseph Balsamo

# Functions
# function: usage(brief)
function usage() {
    echo "Usage: $ ./downloadMarkups.sh [options] -h <host> -f <filename>"
    if [ $1 == false ]
    then
      echo "  Options:"
      echo "    -f <filename>: filename of the data to be loaded (this parameter required)"
      echo "    -h <host>: ip or hostname of database (this parameter required)"
      echo "    -d <database name> (default: quip)"
      echo "    -p <database port> (default: 27017)"
      echo ""
      echo "    --help Display full help usage."
      echo "  Notes: requires mongoDB client tools installed on running server"
      echo "  Notes: If '-f' parameter is *, it must be in quotes."
    fi
}
# end functions

# Set Default variables.
database="quip"
port="3000"
HOST="quip-findapi"
errcode=0
brief=true

while [ -n "$1" ]
# while loop starts
do
case "$1" in
-h) HOST="$2"
    shift;;
-p) port="$2"
    shift ;;

-d) database=${2}
    shift;;

--help)  
    usage false
    exit 0
 
break ;;
 
*) usage true ;;
 
esac
 
shift
 
done

if [ -z "${HOST}" ] || [ -z "${}" ]
then
  echo "Missing required parameters"
  usage true
  exit 1
fi

TYPE=${database}


curl -X GET "http://quip-findapi:3000/?limit=1000000&db=quip&find=\{'provenance.analysis.execution_id':'humanmark','provenance.image.case_id':'TCGA-MV-A51V-01Z-00-DX1','properties.annotations.username':'joseph.balsamo@stonybrook.edu'\}" \
    | awk -F'\\{\\"_id\\":' '{for(i=2;i<=NF;++i){print "\"_id\":"$i}}' \
    | awk -f raw_data_formating.awk | sort -k 5 -n