#!/bin/bash
#
# Dependences: ifconfig, iw, airtrack-ng

[ $EUID != 0 ] && {
  echo "Must root user or sudo run the script!"
  exit 0
}

USAGE () {
  echo "Usage:"
  echo "  bash ${0} [options...] <arg>"
  echo "Options:"
  echo "  -d	Not null, default the first list by wirmon-ng interface"
  echo "  -h	Show usage"
}

domain() {
  [ ! -z $NETDEV ] || NETDEV=$(airmon-ng | grep 'phy0' | awk '{print $2}')

  ifconfig $NETDEV down
  macchanger -r $NETDEV | grep -i "new mac"
  iwconfig $NETDEV mode monitor
  ifconfig $NETDEV up
  iwconfig $NETDEV | grep -i 'mode'
}

doHasopt() {
    while getopts ":i:h" OPT; do
      case $OPT in
        i)
          NETDEV=$OPTARG
          domain
          ;;
        h)
          USAGE
          exit -1
          ;;
        ?)
            USAGE
            exit -1
            ;;
        :)
            USAGE
            exit -1
            ;;
      esac
    done
}

main() {
    [ $# -lt 1 ] && {
      domain
      exit 0
    }
    doHasopt $*
    domain
}

main $*
