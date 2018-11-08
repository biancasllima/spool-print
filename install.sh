#!/bin/bash

if [ $EUID != 0 ]; then
    sudo bash "$0" "$@"
    exit $?
fi

if ! type "git" > /dev/null; then
  # TODO não exibir mensagem ruim do comando acima
  echo 'You need to install git'
  exit $?
fi

LIB_FOLDER=/usr/local/cli_example

if [[ -d $LIB_FOLDER ]]; then
    echo 'removing past version'
    rm -rf $LIB_FOLDER
fi

git clone git@github.com:julioleitao/cli_example.git $LIB_FOLDER
