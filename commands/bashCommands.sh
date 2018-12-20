#!/bin/bash

MY_USER=$(whoami)
WORKING_DIRECTORY=$(pwd)
BASE_DIR=/home/$MY_USER
LOGS_FILE_PATH=$BASE_DIR/.config_lp_commands_log.csv
TMP_FILE_PATH=$BASE_DIR/.config_lp_temp_logs.csv

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

declare -A BUILT_IN_BASH_COMMANDS=( 
 ['exit']=1 ['echo']=1 ['for']=1 ['pwd']=1 ['exec']=1 ['help']=1
 ['alias']=1 ['cd']=1 ['printf']=1 ['eval']=1 ['break']=1 ['return']=1 ['kill']=1 
)

check_built_in_commands () {
  [[ -n "${BUILT_IN_COMMANDS[$1]}" ]] && printf '1'
}

while IFS= read -r COMMAND; do
    IS_BUILT_IN=`check_built_in_commands $COMMAND` 
    
    if [[ "$IS_BUILT_IN" == 1 ]]; then 
      eval $COMMAND 
    else
      /usr/bin/time -o $TMP_FILE_PATH -f 'SU' -p $COMMAND
    
      TIME=`cat $TMP_FILE_PATH`
      printf "${COMMAND},${TIME}" >> $LOGS_FILE_PATH
      rm $TMP_FILE_PATH
    fi
done
printf "\n";