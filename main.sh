#!/bin/bash

echo "RUNNING MAIN"
case "$1" in
"print")
    # https://stackoverflow.com/questions/4824590/propagate-all-arguments-in-a-bash-shell-script
    echo $PWD
    echo "FIND THE PRINT FILE!!!!"
    bash ./lib/print.sh $@
    ;;
"report")
    bash ./lib/report.sh $@
    ;;
*)
    echo 'TODO Show a nice help with the options.'
    ;;
esac
