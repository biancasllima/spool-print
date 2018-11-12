#!/bin/bash

REPORT_FILE_PATH=/home/$(whoami)/.config_lp_report.csv

USUARIOS=$(sort -u -t, -k1,1 $REPORT_FILE_PATH | awk -F "\"*,\"*" '{print $1}')

TIME_FRAME=$(sort -u -t, -k2,3 $REPORT_FILE_PATH | awk -F "\"*,\"*" '{printf "%s %s-",$2, $3}' | sort -u -t, -k1,1)

echo $TIME_FRAME

IFS='-' read -r -a array <<< "$TIME_FRAME"

for FRAME in "${array[@]}"
do
    echo $FRAME
    echo "Uso dos usuarios em $FRAME:"
    for USER in ${USUARIOS// / } ; do 
        IFS=' ' read -ra OUT <<< "$FRAME"
        MONTH=${OUT[0]}
        YEAR=${OUT[1]}
        
        USAGE=$(grep $USER $REPORT_FILE_PATH | grep $MONTH | grep $YEAR | awk -F',' '{x+=$4}END{print x}')
                
        re='^[0-9]+$'
        if ! [[ $USAGE =~ $re ]]; then
            USAGE=0
        fi
        echo "* $USER: $USAGE"
    done
done