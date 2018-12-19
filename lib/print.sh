#!/bin/bash

INIT=$(date +"%T")
export INIT

ACTION=$1
LP_USER=$2
FILE_PATH=$3

MY_USER=$(whoami)
REPORT_FILE_PATH=/home/$MY_USER/.config_lp_report.csv
USERS_FILE_PATH=/home/$MY_USER/.config_lp_users.csv

MONTH=$(date "+%B")
YEAR=$(date "+%Y")

FILE_LINES=`wc -l $FILE_PATH | awk '{ print $1 }'`
PAGES_LINES=$(((FILE_LINES + 59) / 60))

FILE_BYTES=`wc -c $FILE_PATH | awk '{ print $1 }'`
PAGES_BYTES=$(((FILE_BYTES + 3599) / 3600))

if [ $PAGES_BYTES -gt $PAGES_LINES ]; then
  NUM_PAGES=$PAGES_BYTES
else
  NUM_PAGES=$PAGES_LINES
fi



# saber qual eh o valor da conta do usuario
USER_QUOTE=$(grep $LP_USER $USERS_FILE_PATH | awk -F"," '{print $2}')

USAGE=$(grep $LP_USER $REPORT_FILE_PATH | grep $MONTH | grep $YEAR | awk -F',' '{x+=$4}END{print x}')

re='^[0-9]+$'
if ! [[ $USAGE =~ $re ]]; then
    USAGE=0
fi

TOTAL=`expr $USAGE + $NUM_PAGES`
if [ $TOTAL -gt $USER_QUOTE ]; then
    echo "Your quota exceeded"
else
    echo "$LP_USER,$MONTH,$YEAR,$NUM_PAGES" >> $REPORT_FILE_PATH
fi