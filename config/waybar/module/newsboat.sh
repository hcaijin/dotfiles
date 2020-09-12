#!/usr/bin/env bash
# Time: 2020-09-07 21:23:46

NEWSLOG="${XDG_CACHE_HOME:-$HOME/.cache}/newsboat.log"

case "$1" in
  show)
    res="$(newsboat -x print-unread | cut -d ' ' -f1)"
    printf '{"text": "%s", "tooltip": "%s"}\n' "${res}" "${tooltip}"
    ;;
  reload)
    res=""
    printf '{"text": "%s", "tooltip": "%s"}\n' "${res}" "${tooltip}"
    pkill -RTMIN+5 waybar
    newsboat -x reload
    ;;
  *)
    echo "Usage: $0 <show|reload>"
    exit 1
    ;;
esac && pkill -RTMIN+5 waybar
