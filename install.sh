#!/bin/bash
# Init colors
# Reset
Color_off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

# utils
need_cmd () {
    if ! command -v "$1" > /dev/null 2>&1
    then printf "${Red}need '$1' (command not found)${Color_off}\n"
    fi
}

# Symlinks the configs
# Manager func
symlink () {
    TARGET=$PWD/$1
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

if [ ! -d "$HOME/.config" ];then
    mkdir ~/.config
fi

if [ ! -d "$HOME/.ssh" ];then
    mkdir ~/.ssh
fi

if [ ! -d "$HOME/.config/termite" ];then
    mkdir ~/.config/termite
fi

if [ ! -d "$HOME/.config/i3status" ];then
    mkdir ~/.config/i3status
fi

if [ ! -d "$HOME/.config/sway" ];then
    mkdir ~/.config/sway
fi

#install personal.keymap to /usr/local/share/kbd/keymaps/
cp personal.map /usr/local/share/kbd/keymaps/

# Install configuration
symlink 'local/share/fonts'
symlink 'wallpaper'
# pc config
symlink 'config/sway/config'
symlink 'config/i3status/config'
# termite
symlink 'config/termite/config'
# mail
symlink 'offlineimaprc'
symlink 'muttrc'
symlink 'mutt'
if [ ! -f ~/.msmtprc ];
then
    cp msmtprc ~/.msmtprc
    printf "copy ${red}msmtprc to ~/.msmtprc ${color_off}\n"
    printf "you need to run chmod 0600 ~/.msmtprc after edit password\n"
    
fi
symlink 'procmailrc'
symlink 'mailcap'
# windows manager
symlink 'config/vifm'
# fcitx
## pacman -S fcitx fcitx-table-extra
## fcitx-configtool setting the wubi & wubi pinyin
# npm
symlink 'npmrc'
# git
symlink 'gitconfig'
symlink 'gitignore'
#bash
symlink 'zshrc'
symlink 'zprofile'
symlink 'bashrc'
symlink 'wgetrc'
# firefox plugin
symlink 'vimperatorrc'
# bash script
symlink 'scripts'
# bash bin script
symlink 'bin'
# for SpaceVim
symlink 'SpaceVim.d'
# ssh
symlink 'ssh/config'
# rofi
#symlink 'colors'
symlink 'docker'

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

# Install maven bash complete
if [ -e ~/.maven_bash_completion.bash ]
then
    printf "Installed $Red~/.maven_bash_completion.bash$Color_off\n"
else
    printf "$Cyan Downloading maven_bash_completion.bash -> $Blue$HOME/.maven_bash_completion.bash$Color_off\n"
    curl -fLo ~/.maven_bash_completion.bash https://raw.githubusercontent.com/juven/maven-bash-completion/master/bash_completion.bash
    printf "$Blue Finished Installing maven_bash_completion$Color_off\n"
fi

# Install tmux
if [ -e ~/.tmux ]
then
    printf "Installed $Red~/.tmux$Color_off\n"
else
    printf "$Cyan Downloading  tmux -> $Blue$HOME/.tmux$Color_off\n"
    git clone --depth 1 https://github.com/tony/tmux-config.git ~/tmux-config
    ~/tmux-config/install.sh
    printf "$Blue Finished Installing tmux$Color_off\n"
    rm -rf ~/tmux-config
fi

# Install fonts-powerline
# if [ -e ~/.fonts-powerline ]
# then
#     printf "Installed $Red~/.fonts-powerline$Color_off\n"
# else
#     printf "$Cyan Downloading  fonts-powerline -> $Blue$HOME/.fonts-powerline$Color_off\n"
#     git clone --depth 1 https://github.com/powerline/fonts.git ~/.fonts-powerline
#     ~/.fonts-powerline/install.sh
#     printf "$Blue Finished Installing powerline$Color_off\n"
# fi
