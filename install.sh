#!/bin/bash

if ! type "git" > /dev/null; then
  echo 'Make sure you have *git* installed.'
  exit $?
fi

[ ! -d /tmp/spool-print ] || rm -rf /tmp/spool-print
git clone git@github.com:biancasllima/spool-print.git /tmp/spool-print --quiet

install_spool-print() {
    # Mac OS and Linux have the same behavior? Test it!
    LIB_FOLDER=/usr/local/spool-print

    if [[ -d $LIB_FOLDER ]]; then
        rm -rf $LIB_FOLDER
    fi

    mv /tmp/spool-print /usr/local
    chmod 755 /usr/local/spool-print

    ln -s -f /usr/local/spool-print/main.sh /usr/local/bin/lp
    chmod 755 /usr/local/bin/lp
}

if [ $EUID != 0 ]; then
    FUNC=$(declare -f install_spool-print)
    sudo bash -c "$FUNC; install_spool-print"
    ## TODO Error message in case the user is not able to install the program.
    echo "Success! Now you can use *lp* to print and display reports."
    exit $?
fi
