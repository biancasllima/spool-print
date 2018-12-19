#!/bin/bash

MY_USER=$(whoami)
WORKING_DIRECTORY=$(pwd)
HOST=`hostname`
BASE_DIR=/home/$MY_USER
LOGS_FILE_PATH=$BASE_DIR/.commands-logs.csv
TMP_FILE_PATH=$BASE_DIR/.temp-logs.csv

# Creating commands logs file
if [ ! -f $LOGS_FILE_PATH ]; then
  cat > $LOGS_FILE_PATH <<EOL
EOL
fi

# Creating temp file
if [ ! -f $TMP_FILE_PATH ]; then
  cat > $TMP_FILE_PATH <<EOL
EOL
fi

declare -A BUILT_IN_COMMANDS=( 
 ['alias']=1  ['cd']=1 ['printf']=1 ['eval']=1 ['break']=1 ['builtin']=1 ['caller']=1 ['echo']=1 ['exec']=1
 ['return']=1 ['exit']=1 ['export']=1 ['for']=1 ['pwd']=1 ['kill']=1 ['help']=1
)

check_commands () {
  [[ -n "${BUILT_IN_COMMANDS[$1]}" ]] && printf '1'
}


while IFS= read -r COMMAND; do
    IS_BUILT_IN=`check_commands $COMMAND` 
    
    if [[ "$IS_BUILT_IN" == 1 ]]; then 
      eval $COMMAND 
    else
      /usr/bin/time -o $TMP_FILE_PATH -f 'SU' -p $COMMAND
    
      TIME=`cat $TMP_FILE_PATH`

      printf "${COMMAND},${TIME} \n~\n" >> $LOGS_FILE_PATH
      rm $TMP_FILE_PATH
    fi

    #printf "${MY_USER}@${HOST}:${PWD}$ " ;

done
printf "\n";