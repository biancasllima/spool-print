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
  
  # Do not remove, this is functions return
  echo "$DIR"
}

MY_USER=$(whoami)
USERS_FILE_PATH=/home/$MY_USER/.config_lp_users.csv
REPORT_FILE_PATH=/home/$MY_USER/.config_lp_report.csv
DEFAULT_QUOTE=50;

ACTION=$1
LP_USER=$2
FILE_PATH=$3

TIMESTAMP=$(date "+%d/%m/%Y")
echo $TIMESTAMP

# Creating users file
if [ ! -f $USERS_FILE_PATH ]; then
  echo -e "nao tem o arquivo USERS***"
  cat > $USERS_FILE_PATH <<EOL
EOL
fi

# Creating report file
if [ ! -f $REPORT_FILE_PATH ]; then
  echo -e "nao tem o arquivo REPORT***"
  cat > $REPORT_FILE_PATH <<EOL
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
    echo 'TODO Help message'
    ;;
*)
    echo 'You may be looking for one of this actions using "lp":'
    echo ''
    echo 'print <user> <file>'
    echo 'report'
    echo ''
    echo 'More informations in lp --help'
    ;;
esac
