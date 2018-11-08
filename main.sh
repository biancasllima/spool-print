#!/bin/bash

case "$1" in
"print")
    # https://stackoverflow.com/questions/4824590/propagate-all-arguments-in-a-bash-shell-script
    bash lib/print.sh $@
    ;;
"report")
    bash lib/report.sh $@
    ;;
*)
    echo 'TODO Show a nice help with the options.'
    ;;
esac
