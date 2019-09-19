#!/bin/bash
#
# Init colors
# Reset
Color_off='\033[0m'       # Text Reset

# Regular Colors
Cyan='\033[0;36m'
Blue='\033[0;34m'
Red='\033[0;31m'


PRE=.orig

delink () {
  TARGET=$PWD/$1
  FILE=$HOME/.$1
  if [ -e "$FILE" ]
  then
    if file $FILE | grep $PWD &> /dev/null;then
        rm -rf "$FILE"
        printf "Removed File $Blue$FILE${Color_off}\n"
    else
        printf "Skipping $Red$FILE${Color_off}\n"
    fi
  else
    printf "None File $Red$FILE${Color_off}\n"
  fi
}

deldel () {
  FILE=$HOME/.$1
  OFILE=$FILE$PRE
  if [ -e "$FILE" ]
  then
    mv "$FILE" "$FILE$PRE"
    printf "Removed File $Cyan$FILE${Color_off} to $Blue$OFILE${Color_off}\n"
  else
    printf "None File $Red$FILE${Color_off}\n"
  fi
}

delink 'local/share/fonts'
delink 'wallpaper'
# pc config
delink 'config/sway/config'
delink 'config/i3status/config'
# termite
delink 'config/termite/config'
# mail
delink 'muttrc'
delink 'mutt'
# windows manager
delink 'config/vifm'
# npm
delink 'npmrc'
# git
delink 'gitconfig'
delink 'gitignore'
#bash
delink 'zshrc'
delink 'zprofile'
delink 'bashrc'
delink 'wgetrc'
# firefox plugin
delink 'vimperatorrc'
# bash script
delink 'scripts'
# bash bin script
delink 'bin'
# for SpaceVim
delink 'SpaceVim.d'
# ssh
delink 'ssh/config'
# rofi
#delink 'colors'

#deldel 'fzf'
#deldel 'maven_bash_completion.bash'
#deldel 'tmux'
