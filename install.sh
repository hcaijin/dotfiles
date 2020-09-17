#!/usr/bin/env bash
Color_off='\033[0m'
Cyan='\033[0;36m'
Blue='\033[0;34m'
Red='\033[0;31m'

PRE=.orig
GITUSER='hcaijin'
LOCKFILE=$PWD/dotfiles.lock
[ $EUID != 0 ] && SUDO=sudo

if type apt >/dev/null 2>&1; then
  installpkg(){ ${SUDO} apt-get install -y "$@" >/dev/null 2>&1; }
elif type pkg >/dev/null 2>&1; then
  installpkg(){ ${SUDO} pkg install -y "$@" >/dev/null 2>&1; }
elif type yum >/dev/null 2>&1; then
  installpkg(){ ${SUDO} yum install -y "$@" >/dev/null 2>&1; }
else
  installpkg(){ ${SUDO} pacman --noconfirm --needed -S "$@" >/dev/null 2>&1 ;}
fi

USAGE () {
  echo "Usage:"
  echo "  bash install.sh [options...] <arg>"
  echo "Options:"
  echo "  -g	Get the public key from GitHub, the arguments is the GitHub ID, default my github id (hcaijin)"
  echo "  -p	Change sshd listen port"
  echo "  -P	The sshd key password, default null"
  echo "  -f	Force links installed file"
  echo "  -d	Uninstall and Delete links"
  echo "  -h	Show usage"
}

delink () {
  FILE=$HOME/.$1
  OLDLINK=$FILE$PRE
  if [ -e "$FILE" ]
  then
    if file $FILE | grep $PWD &> /dev/null;then
      rm -r "$FILE"
      # mv $FILE $OLDLINK
      printf "Removed File $Blue$FILE${Color_off}\n"
      if [ -e "$OLDLINK" ]; then
        printf "Restore $Cyan$OLDLINK${Color_off} -> $Blue$FILE${Color_off}\n"
        mv $OLDLINK $FILE
      fi
    else
      printf "Skipping $Red$FILE${Color_off}\n"
    fi
  else
    printf "None File $Red$FILE${Color_off}\n"
  fi
}

doUninstall() {
  if [ ! -e "$LOCKFILE" ]
  then
    echo "Nothing to do!! Please check you lock exit!"
    exit
  fi
  if [ -e ~/.fzf ]
  then
    if [ -e ~/.fzf.orig ]
    then
      rm -rf ~/.fzf.orig
    fi
    mv ~/.fzf ~/.fzf.orig
  fi
  for file in `cat $LOCKFILE | sort -n | uniq`;
  do
    delink $file
  done
  rm $LOCKFILE
}

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
      if [[ $FORCE -eq 1 ]]; then
        mv -f "$FILE" "$FILE$PRE"
        ln -sf "$TARGET" "$FILE"
        printf "Linking $Cyan$FILE${Color_off} -> $Blue$TARGET${Color_off}\n"
      else
        printf "Skipping $Red$FILE${Color_off}\n"
      fi
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
  for file in `ls $1 | egrep -v '^(etc)'`;
  do
    symlink $1/$file
  done
}

doLink() {
  # mkdir
  if [ ! -d "$HOME/.config" ];then
    mkdir ~/.config
  fi
  if [ ! -d "$HOME/.local/bin" ];then
    mkdir -p ~/.local/bin
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
    if [ -e ~/.fzf.orig ]
    then
      mv ~/.fzf.orig ~/.fzf
      printf "$Blue Finished Installing fzf$Color_off\n"
    else
      printf "$Cyan Downloading  fzf -> $Blue$HOME/.fzf$Color_off\n"
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install --all --no-update-rc
      printf "$Blue Finished Installing fzf$Color_off\n"
    fi
  fi
}

domain() {
  echo "do install depandens pkg"
  installpkg wget curl vim zsh keychain
  doLink
  # Pull github ssh pub key
  [ -z ${PASSWD} ] || PASSWD_STR=" -P $PASSWD"
  [ -z ${PORT} ] || PORT_STR=" -p $PORT"
  [ -f "$HOME/.ssh/id_ecdsa" ] || sh <(curl -Ls https://raw.githubusercontent.com/hcaijin/SSH_Key_Installer/master/ikey.sh)${PASSWD_STR}${PORT_STR} -g $GITUSER -d
  [ -z "`echo $SHELL | grep 'zsh'`" ] && chsh -s `which zsh`
}

doEditSystem() {
  # https://wiki.archlinux.org/index.php/Security
  sudo sed -i 's/# deny.*/deny = 50/g' /etc/security/faillock.conf
  # https://wiki.archlinux.org/index.php/Systemd/Journal#Clean_journal_files_manually
  sudo sed -i 's/#SystemMaxUse=.*/SystemMaxUse=200M/g' /etc/systemd/journald.conf
}

doHasopt() {
  while getopts "P:p:g:hfd" OPT; do
    case $OPT in
      P)
        PASSWD=$OPTARG
        ;;
      p)
        PORT=$OPTARG
        ;;
      g)
        GITUSER=$OPTARG
        ;;
      f)
        FORCE=1
        ;;
      d)
        doUninstall
        exit
        ;;
      h)
        USAGE
        exit -1
        ;;
      ?)
        USAGE
        exit -1
        ;;
      :)
        USAGE
        exit -1
        ;;
    esac
  done
}

main() {
  [ $# -lt 1 ] && {
    domain
      exit 0
    }
  doHasopt $*
  domain
  doEditSystem
}

main $*
