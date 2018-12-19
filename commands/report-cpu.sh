#!/bin/bash
#SYS 7
#USR 5
#REAL 3
if [ "$#" -ne 2 ]; then
  echo "Error: Check parameters..."
  echo "Executing this command using: ./report [MONTH_NUMBER] [YEAR_NUMBER]"
  exit 1
fi

MY_USER=$(whoami)
BASE_DIR=/home/$MY_USER
ROOT_FOLDER=$HOME/.logs

MONTH=$(date "+%B")
YEAR=$(date "+%Y")

DATE=$(date -d "$2$101" +"%b-%Y")
FILE=$DATE.log
REPORT_FOLDER="$ROOT_FOLDER/${MY_USER}"
REPORT_FOUND=`find $REPORT_FOLDER -name $FILE`

if [ -n "$REPORT_FOUND" ];
then
  REPORT=`cat $REPORT_FOUND`
  awk -vRS="~" '{for (i =1; i<=NF; i++) {
                   if ($i == "real")
                     {BASE_INDEX=i;};
                 }; 
                 SYS_INDEX=BASE_INDEX+5;
                 MY_USER_INDEX=BASE_INDEX+3;
                 REAL_INDEX=BASE_INDEX+1;
                 TIME_SYS+=int($SYS_INDEX);
                 TIME_USR+=int($MY_USER_INDEX); 
                 TIME_TOTAL+=int($REAL_INDEX); 
                COMMANDS+=$1;} END  {print "Tempo total de uso: " TIME_TOTAL; print "Tempo total sys: " TIME_SYS; print "Tempo total user: " TIME_USR}' $REPORT_FOUND

  #Histograma de comandos

  awk -vRS="~" '{if ($1 != "") {print $1}}' $REPORT_FOUND >> $REPORT_FOLDER/cmd-tmp.txt
  sort -n $REPORT_FOLDER/cmd-tmp.txt | uniq -c
  rm $REPORT_FOLDER/cmd-tmp.txt
else
  echo "No report available for date: $MONTH - $YEAR"
fi
