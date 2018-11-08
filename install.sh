#!/bin/bash

if ! type "git" > /dev/null; then
  # TODO não exibir mensagem ruim do comando acima
  echo 'You need to install git'
  exit $?
fi

[ ! -d /tmp/spool-print ] || rm -rf /tmp/spool-print
git clone git@github.com:biancasllima/spool-print.git /tmp/spool-print --quiet

function install_spool-print {
    LIB_FOLDER=/usr/local/spool-print

    if [[ -d $LIB_FOLDER ]]; then
        echo 'removing past version'
        rm -rf $LIB_FOLDER
    fi

    mv /tmp/spool-print /usr/local
    chmod 755 /usr/local/spool-print

    ln -s -f /usr/local/spool-print/main.sh /usr/bin/spool-print
    chmod 755 /usr/bin/spool-print
}

if [ $EUID != 0 ]; then
    FUNC=$(declare -f install_spool-print)
    sudo bash -c "$FUNC; install_spool-print"
    echo "Sucess! TODO colocar mensagem"
    exit $?
fi
