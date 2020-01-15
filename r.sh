#!/bin/bash

# r - based on "rscreen"
# connects to remote host and reattaches screen session
# dependencies: perl, autossh

# print usage info if called without arguments
if [ "X$1" = "X" ]; then
	echo "usage: `basename $0` <host>"
	exit 1
fi

# add identity if $SSH_AUTH_SOCK is unset
if [ "X$SSH_AUTH_SOCK" = "X" ]; then
    eval `ssh-agent -s`
    ssh-add $HOME/.ssh/id_rsa
fi

# check every 5 seconds if session is still alive:
AUTOSSH_POLL=5

#AUTOSSH_GATETIME=30
#AUTOSSH_LOGFILE=$HOST.log

# enable autossh debug mode?
# AUTOSSH_DEBUG=yes

#AUTOSSH_PATH=/usr/local/bin/ssh
export AUTOSSH_POLL AUTOSSH_LOGFILE AUTOSSH_DEBUG AUTOSSH_PATH AUTOSSH_GATETIME AUTOSSH_PORT

# use random port between 20000 and 20100:
portnum="$(perl -e 'print int(rand(100-1)) + 20000')"

# display info message if debug mode is enabled
if [[ x"$AUTOSSH_DEBUG" != x ]]; then
  echo "autossh debug mode enabled..."
else
  echo "autossh debug mode disabled..."
fi

echo "executing autossh with port number $portnum ..."
sleep 2

# finally start autossh:
autossh -M $portnum -t $1 "screen -D -R"

# debug:
echo "autossh return code was: $?"

