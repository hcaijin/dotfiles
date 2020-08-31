#!/usr/bin/env zsh
# Time: 2020-08-31 01:58:53
# forks from https://github.com/ammgws/dotfiles/blob/master/fish/.config/fish/functions/sway_getwindowinfo.fish

! pkill -x slurp || exit

WININFO="${XDG_CACHE_HOME:-$HOME/.cache}/sway-getwindowninfo.log"

rm $WININFO

slurp -p -f "%x %y" | read -r x_sel y_sel

swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x) \(.width) \(.y) \(.height)"' |
  while read -r rect
  do
    echo $rect | read -r x1 w y1 h
    x2=$((x1+w))
    y2=$((y1+h))
    if [[ $x_sel -ge $x1 && $x_sel -le $x2 ]] && [[ $y_sel -ge $y1 && $y_sel -le $y2 ]]; then
      # swaymsg --type get_tree | jq ".. | objects | select(.rect.x == $x1 and .rect.y == $y1 and .rect.width == $w and .rect.height == $h) | .id, .name, .pid, .title, .app_id, .marks, .type"
      swaymsg --type get_tree | jq ".. | objects | select(.rect.x == $x1 and .rect.y == $y1 and .rect.width == $w and .rect.height == $h)" >> $WININFO
    fi
  done

$TERMINAL -e "less -S $WININFO"
