#!/usr/bin/env bash
# Time: 2020-08-29 13:10:23

case $1 in
  night)
    exec notify-send "Gammastep Night:" "$2 Period changed to $3"
    ;;
  daytime)
    exec notify-send "Gammastep Daytime" "$2 Period changed to $3"
    ;;
  transition)
    exec notify-send "Gammastep Other" "$2 Period changed to $3"
    ;;
  *)
    echo >&2 "Usage: This's gammastep hook!"
    ;;
esac
