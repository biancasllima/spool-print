#!/bin/bash

get_script_dir () {
  SOURCE="${BASH_SOURCE[0]}"
  # While $SOURCE is a symlink, resolve it
  while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$( readlink "$SOURCE" )"
    # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  
  # Do not remove, this is the function return
  echo "$DIR"
}

MY_USER=$(whoami)
USERS_FILE_PATH=/home/$MY_USER/.config_lp_users.csv
REPORT_FILE_PATH=/home/$MY_USER/.config_lp_report.csv
COMMANDS_LOG_FILE_PATH=/home/$MY_USER/.config_lp_commands_log.csv
UCP_USE_FILE_PATH=/home/$MY_USER/.config_lp_upc_use.csv
DEFAULT_QUOTE=50;

ACTION=$1
LP_USER=$2
FILE_PATH=$3

# Creating users file
if [ ! -f $USERS_FILE_PATH ]; then
  cat > $USERS_FILE_PATH <<EOL
EOL
fi

# Creating report file
if [ ! -f $REPORT_FILE_PATH ]; then
  cat > $REPORT_FILE_PATH <<EOL
EOL
fi

# * ATTENTION *
# TODO Create variable to get time in main.sh and export to all bashscripts
# Use this variable to keep initial timestamp and then compare with all final timestamps at each bashscript.

# Creating Commands log file
if [ ! -f $COMMANDS_LOG_FILE_PATH ]; then
    cat > $COMMANDS_LOG_FILE_PATH <<EOL
EOL
fi

# Creating UCP use file
if [ ! -f $UCP_USE_FILE_PATH ]; then
    cat > $UCP_USE_FILE_PATH <<EOL
EOL
fi

# For unregistered users
HAS_USER=$(grep "$LP_USER" "$USERS_FILE_PATH")
if [ -z "$HAS_USER" ]; then 
  echo "$LP_USER,$DEFAULT_QUOTE " >> $USERS_FILE_PATH
fi

DIR=$(get_script_dir)

case $ACTION in
"print")
    # https://stackoverflow.com/questions/4824590/propagate-all-arguments-in-a-bash-shell-script
    bash $DIR/lib/print.sh $@
    ;;
"report")
    bash $DIR/lib/report.sh $@
    ;;
"--help")
    echo ' You can use lp to print files and to display reports for users and its monthly quota. Important: the default quota is *50 pages*!
    
    print: Print a file if its page count does not exceed the month quota. Use it with 2 parameters: user and file. E.g.: 
print my_user my_file.txt

    report: Displays all the users consumption per month and year. There is no need for parameters.
  
    '
    ;;
*)
    echo 'You may be looking for one of this actions using *lp*:
      
    print 
    report

For more informations use: lp --help'
    ;;
esac
