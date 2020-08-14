#!/usr/bin/env sh
LOGFILE=/tmp/checkpacmanupdate.log
if [[ "$(stat -c %y "$LOGFILE" 2>/dev/null | awk '{print $1}')" != "$(date '+%Y-%m-%d')" ||  ! -z $1 ]]; then
  checkupdates > ${LOGFILE} || exit
  pkill -SIGRTMIN+8 waybar
fi
COUNTNUM=$(wc -l ${LOGFILE} | awk '{print $1}')
PACKAGES=$(cat ${LOGFILE} | awk '{print $1}')
echo -e "{\"text\":\""${COUNTNUM}"\", \"tooltip\":\""${PACKAGES}"\"}"
