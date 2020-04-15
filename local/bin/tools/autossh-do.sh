#!/usr/bin/env bash
# Time: 2020-04-15 17:17:31

USAGE () {
  echo "Usage:"
  echo "  bash autossh-do.sh [options...] <arg>"
  echo "Options:"
  echo "  -p	The remot host listen port"
  echo "  -l	The local host listen port"
  echo "  -h	The remot host who is proxy service"
  echo " Example: bash autossh-do.sh -p 2222 -l 22 -h test.host.com"
}

if [ $# -lt 4 ]; then
  USAGE
  exit -1
fi

while getopts "p:l:h:" OPT; do
  case $OPT in
    p)
      REMOTE_PORT=$OPTARG
      ;;
    l)
      LOCAL_PORT=$OPTARG
      ;;
    h)
      REMOTE_HOST=$OPTARG
      ;;
    :)
      USAGE
      exit -1
      ;;
    *)
      USAGE
      exit -1
      ;;
    ?)
      USAGE
      exit -1
      ;;
  esac
done

manage_port=`expr ${REMOTE_PORT} + 1`

autossh -M ${manage_port} \
  -o "PasswordAuthentication=no" \
  -o "PubkeyAuthentication=yes" \
  -o "StrictHostKeyChecking=false" \
  -o "ServerAliveInterval 60" \
  -o "ServerAliveCountMax 3" \
  -fCNR ${REMOTE_PORT}:localhost:${LOCAL_PORT} \
  ${REMOTE_HOST}
