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
  
  # Nao me remova. Sou o retorno da funcao
  echo "$DIR"
}
DIR=$(get_script_dir)

case "$1" in
"print")
    # https://stackoverflow.com/questions/4824590/propagate-all-arguments-in-a-bash-shell-script
    echo $PWD
    echo "FIND THE PRINT FILE!!!!"
    bash $DIR/lib/print.sh $@
    ;;
"report")
    bash $DIR/lib/report.sh $@
    ;;
*)
    echo 'TODO Show a nice help with the options.'
    ;;
esac
