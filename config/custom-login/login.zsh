#!/usr/bin/env zsh
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  export GDK_BACKEND=x11

  # export GTK_IM_MODULE=fcitx
  # export QT_IM_MODULE=fcitx
  # export XMODIFIERS="@im=fcitx"

  export _JAVA_AWT_WM_NONREPARENTING=1
  # Disabling client-side Qt decorations
  # export QT_QPA_PLATFORM=wayland
  # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  # Blank window in Java application.

  #
  # # mpv midea and music
  # MPD daemon start (if no other user instance exists)
  [ ! -s ~/.config/mpd/pid ] && mpd 2>&1 >/dev/null &
  #
  # Sway start
  # exec sway -d 2> /tmp/sway.log # sway debug

  # The first card is used for actual rendering, and display buffers are copied to the secondary cards for any displays connected to them.
  # WLR_DRM_DEVICES=/dev/dri/card0 exec sway 2>/tmp/sway.log

  [ ! -d ~/tmp/ ] || mkdir ~/tmp
  XKB_DEFAULT_LAYOUT=us exec sway 2> ~/tmp/sway.log

fi
