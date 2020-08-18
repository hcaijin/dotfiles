#!/usr/bin/env sh

localt=$(file /etc/localtime 2>/dev/null | awk -F'/' '{print $NF}')
[ ! -z "$localt" ] || localt="Shanghai"
LOCALTION="${LOCAL:-$localt}"

report=$HOME/.local/share/weatherreport
full_report=$HOME/.local/share/weatherreport.full

getweather() {
  curl -s "wttr.in/{$LOCALTION}?0qm&format=%l:+%c+%t\n" > "$report" || exit
}

showeather() {
  text=$(awk -F':' '{print $NF}' $report)
  if [ "$text" != "" ]
  then
    res=$(echo $text | awk '{print $1$2}')
    [[ "$res" != "Unknowlocation" ]] || exit 3
    echo -e "{\"text\":\""${res}"\", \"tooltip\":\""$(showfullweather)"\"}"
  else
    getweather && showeather
  fi
}

showfullweather() {
  awk '{print $1" "$2" "$3}' $report
}

showontermite() {
  swaymsg -q "exec $TERMINAL -e \"less -S $full_report\""
}

if [[ "${1}" == "term" ]]
then
  showontermite
  exit 0
fi

if [ "$(stat -c %y "$report" 2>/dev/null | awk '{print $1}')" != "$(date '+%Y-%m-%d')" ]
then
  getweather && showeather
else
  # showfullweather
  showeather
fi
if [ "$(stat -c %y "$full_report" 2>/dev/null | awk '{print $1}')" != "$(date '+%Y-%m-%d')" ]
then
  curl -s "wttr.in/{$LOCALTION}?2qnmFM" > "$full_report" || exit
fi