#!/usr/bin/env bash

localt=$(file /etc/localtime 2>/dev/null | awk -F'/' '{print $NF}')
[ ! -z "$localt" ] || localt="Shanghai"
LOCALTION="${LOCAL:-$localt}"

report=$HOME/.local/share/weatherreport

getweather() {
  curl -s "wttr.in/{$LOCALTION}?0qm&format=%l:+%c+%t\n" > "$report" || exit
}

showeather() {
  text=$(awk -F':' '{print $NF}' $report)
  if [ "$text" != "" ]
  then
    res=$(echo $text | awk '{print $1$2}')
    [[ "$res" != "Unknowlocation" ]] || exit 3
    tooltip="$(printf "$(cat $report)" | perl -pe 's/\n/\\n/g' | perl -pe 's/(?:\\n)+$//')"
    printf '{"text": "%s", "tooltip": "%s"}\n' "${res}" "${tooltip}"
  else
    getweather && showeather
  fi
}

case "$1" in
  show)
    if [ "$(stat -c %y "$report" 2>/dev/null | awk '{print $1}')" != "$(date '+%Y-%m-%d')" ]
    then
      getweather && showeather
    else
      showeather
    fi
    ;;
  refresh)
    getweather
    pkill -RTMIN+9 -x waybar
    ;;
  *)
    echo >&2 "Usage: $0 <show|refresh>"
    ;;
esac
