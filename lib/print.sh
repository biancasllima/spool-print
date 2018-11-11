#!/bin/bash

echo 'Printing your file...'

ACTION=$1
LP_USER=$2
FILE_PATH=$3

MY_USER=$(whoami)
REPORT_FILE_PATH=/home/$MY_USER/.config_lp.csv

TIMESTAMP=$(date "+%d/%m/%Y")

#Need to verify parameters existency
#
# if [[ -z $LP_USER ]]; then
#   echo "Problem: Specify the user printing the file"
#   exit 1
# fi

# if [[ -z $FILE_PATH ]]; then
#   echo "Problem: Specify a file to be printed"
#   exit 1
# fi

FILE_LINES=`wc -l $FILE_PATH | awk '{ print $1 }'`
PAGES_LINES=$(((FILE_LINES + 59) / 60))

FILE_BYTES=`wc -c $FILE_PATH | awk '{ print $1 }'`
PAGES_BYTES=$(((FILE_BYTES + 3599) / 3600))

if [ $PAGES_BYTES -gt $PAGES_LINES ]; then
  num_pages=$PAGES_BYTES
else
  num_pages=$PAGES_LINES
fi

echo 'Action: ' $ACTION 

echo 'User: ' $LP_USER

echo 'File path modified: ' $FILE_PATH
