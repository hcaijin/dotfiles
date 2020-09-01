#!/usr/bin/env bash
# Time: 2020-08-31 17:34:45

case "$1" in
  set)
    light -S $2
    ;;
  up)
    light -A $2
    ;;
  down)
    light -U $2
    ;;
  *)
    echo >&2 "Usage: $0 <set|up|down> <int..0-100>"
    exit 1
    ;;
esac && light -G | cut -d '.' -f1 > $SWAYSOCK.wob
