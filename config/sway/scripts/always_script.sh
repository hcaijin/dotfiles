#!/usr/bin/env bash
# Time: 2020-08-29 13:10:23
# 自定义启动脚本

pkill -x waybar && "kill waybar success"
waybar &

pkill -x sway-autoname-w && echo "kill sway-autoname-workspaces success"
sway-autoname-workspaces -d -l ~/.cache/sway-autoname-wp.log &

pkill -f inactive-windows-transparency.py && echo "kill inactive-windows-transparency success"
~/.config/sway/scripts/inactive-windows-transparency.py -o 0.7 &

pkill -9 -f auto-change-bg && echo "kill auto-change-bg success"
auto-change-bg &
