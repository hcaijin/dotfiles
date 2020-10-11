#!/usr/bin/env bash

FETCHLOG="${XDG_CACHE_HOME:-$HOME/.cache}/neofetch.log"

printlogo() {
  [ -f "$FETCHLOG" ] || neofetch > $FETCHLOG
  printf "%s" $(cat $FETCHLOG | grep 'OS' | awk '{print $2$3}')
}

refresh() {
  neofetch > $FETCHLOG
  notify-check-send "Neofetch" "updating..."
  sleep 1
  showfetch
}

showfetch(){
  $TERMINAL --display=$DISPLAY --hold -t "neofetch" -e "cat $FETCHLOG"
}

case "$1" in
  logo)
    printlogo
    ;;
  show)
    showfetch
    ;;
  refresh)
    refresh
    ;;
  *)
    echo "Usag: $0 {logo|show|refresh}"
    exit
    ;;
esac
