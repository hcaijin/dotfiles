#!/bin/bash
#
# Init colors
# Reset
Color_off='\033[0m'       # Text Reset

# Regular Colors
Cyan='\033[0;36m'
Blue='\033[0;34m'
Red='\033[0;31m'

LOCKFILE=$PWD/dotfiles.lock

# Symlinks the configs
symlink () {
  grep "$1" $LOCKFILE 2>/dev/null
  if [ $? != 0 ]
  then
    echo $1 >> $LOCKFILE
  fi
  TARGET=$PWD/$2$1
  FILE=$HOME/.$1
  if [ -e "$FILE" ]
  then
    if file $FILE | grep $PWD &> /dev/null;then
      printf "Installed $Red$FILE${Color_off}\n"

  else
      printf "Skipping $Red$FILE${Color_off}\n"
    fi
  else
    printf "Linking $Cyan$FILE${Color_off} -> $Blue$TARGET${Color_off}\n"
    ln -s "$TARGET" "$FILE"
  fi
}

linkHiddenFile() {
  for file in `ls hiddenrc`;
  do
    symlink $file hiddenrc/
  done
}

linkFolder() {
  for file in `ls $1 | egrep -v '^(etc|share)'`;
  do
    symlink $1/$file
  done
}

main() {
  # mkdir
  if [ ! -d "$HOME/.config" ];then
    mkdir ~/.config
  fi
  if [ ! -d "$HOME/.local/sbin" ];then
    mkdir ~/.local/sbin
  fi
  # mail
  if [ ! -f ~/.msmtprc ];
  then
    #cp msmtprc ~/.msmtprc
    printf "copy ${red}msmtprc to ~/.msmtprc ${color_off}\n"
    printf "you need to run chmod 0600 ~/.msmtprc after edit password\n"

  fi
  # Install folder to config or local
  linkFolder config
  linkFolder local/bin
  linkFolder local/share
  # Install hidden file to ~
  linkHiddenFile
  # Install FZF
  if [ -e ~/.fzf ]
  then
    printf "Installed $Red~/.fzf$Color_off\n"
  else
    printf "$Cyan Downloading  fzf -> $Blue$HOME/.fzf$Color_off\n"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    printf "$Blue Finished Installing fzf$Color_off\n"
  fi
  if [ -e ~/.oh-my-zsh || ! `command -v zsh` ]
  then
    printf "Unknow zsh command or Installed $Red~/.oh-my-zsh$Color_off\n"
  else
    printf "$Cyan Downloading  oh-my-zsh -> $Blue$HOME/.oh-my-zsh$Color_off\n"
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
    [ -z "`grep "autoload -U compinit && compinit" ~/.zshrc`" ] && echo "autoload -U compinit && compinit" >> ~/.zshrc
    sed -i '/^plugins=/c\plugins=(git z zsh-syntax-highlighting zsh-autosuggestions zsh-completions)' ~/.zshrc
    sed -i '/^ZSH_THEME=/c\ZSH_THEME="ys"' ~/.zshrc

    printf "$Blue Finished Installing oh-my-zsh$Color_off\n"
  fi
}

main
