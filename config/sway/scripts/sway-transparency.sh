#!/usr/bin/env bash
# Time: 2020-08-25 11:28:08
# 桌面软件透明功能开关,只对新打开软件有效- -

pkill -f inactive-windows-transparency.py || ~/.config/sway/scripts/inactive-windows-transparency.py -o "0.7"
