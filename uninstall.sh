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
  FILE=$HOME/.$1
  OLDLINK=$FILE$PRE
  if [ -e "$FILE" ]
  then
    if file $FILE | grep $PWD &> /dev/null;then
        rm -rf "$FILE"
        # mv $FILE $OLDLINK
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

domain() {
  LOCKFILE=$PWD/dotfiles.lock
  if [ ! -e "$LOCKFILE" ]
  then
    echo "Nothing to do!! Please check you lock exit!"
    exit
  fi
  if [ -e ~/.fzf ]
  then
    ~/.fzf/uninstall
    if [ -e ~/.fzf.orig ]
    then
      rm -rf ~/.fzf.orig
    fi
    mv ~/.fzf ~/.fzf.orig
  fi
  if [ -e ~/.tmux ]
  then
    if [ -e ~/.tmux.orig ]
    then
      rm -rf ~/.tmux.orig
    fi
    mv ~/.tmux ~/.tmux.orig
    rm ~/.tmux.conf
  fi
  for file in `cat $LOCKFILE | sort -n | uniq`;
  do
    delink $file
  done
  rm $LOCKFILE
}

domain
