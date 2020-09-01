#!/usr/bin/env bash
# Time: 2020-08-31 17:34:45

case "$1" in
  toggle)
    # amixer sset Master toggle
    pamixer --toggle-mute && ( pamixer --get-mute && echo 0 > $SWAYSOCK.wob ) || pamixer --get-volume > $SWAYSOCK.wob
    exit 1
    ;;
  up)
    # amixer sset Master 5%+ | sed -En 's/.*\[([0-9]+)%\].*/\1/p' | head -1 > $SWAYSOCK.wob
    pamixer -ui $2
    ;;
  down)
    # amixer sset Master 5%-
    pamixer -ud $2
    ;;
  *)
    echo >&2 "Usage: $0 [<up|down> <int..0-100>] [<toggle>]"
    exit 1
    ;;
esac  && pamixer --get-volume > $SWAYSOCK.wob
