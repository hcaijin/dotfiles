#!/usr/bin/env bash
# Time: 2020-08-16 17:28:13

# utility functions
# this function checks if a command exists and returns either true
# or false. This avoids using 'which' and 'whence', which will
# avoid problems with aliases for which on certain weird systems. :-)
# Usage: check_com [-c|-g] word
#   -c  only checks for external commands
#   -g  does the usual tests and also checks for global aliases
function check_com () {
    emulate -L zsh
    local -i comonly gatoo
    comonly=0
    gatoo=0

    if [[ $1 == '-c' ]] ; then
        comonly=1
        shift 1
    elif [[ $1 == '-g' ]] ; then
        gatoo=1
        shift 1
    fi

    if (( ${#argv} != 1 )) ; then
        printf 'usage: check_com [-c|-g] <command>\n' >&2
        return 1
    fi

    if (( comonly > 0 )) ; then
        (( ${+commands[$1]}  )) && return 0
        return 1
    fi

    if     (( ${+commands[$1]}    )) \
        || (( ${+functions[$1]}   )) \
        || (( ${+aliases[$1]}     )) \
        || (( ${+reswords[(r)$1]} )) ; then
        return 0
    fi

    if (( gatoo > 0 )) && (( ${+galiases[$1]} )) ; then
        return 0
    fi

    return 1
}



make() {
   [ "$1" == 'install' ] &&
     echo -e "WARNING:\nDON'T INSTALL SOFTWARE MANUALY\nDON'T USE unset make TO OVERRIDE" &&
     echo "Tip: It's easy to make own custom package see: man PKGBUILD makepkg" &&
     return 1;
   /usr/bin/make $@;
 }

cl() {
    local dir="$1"
    local dir="${dir:=$HOME}"
    if [[ -d "$dir" ]]; then
        cd "$dir" >/dev/null; ls
    else
        echo "bash: cl: $dir: Directory not found"
    fi
}


calc() {
    echo "scale=3;$@" | bc -l
}

inote () {
    # if file doesn't exist, create it
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/.notes"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/.notes"
    elif [[ "$1" == "-c" ]]; then
        # clear file
        > "$HOME/.notes"
    else
        # add all arguments to file
        printf "%s\n" "$*" >> "$HOME/.notes"
    fi
}

todo() {
    if [[ ! -f $HOME/.todo ]]; then
        touch "$HOME/.todo"
    fi

    if ! (($#)); then
        cat "$HOME/.todo"
    elif [[ "$1" == "-l" ]]; then
        nl -b a "$HOME/.todo"
    elif [[ "$1" == "-c" ]]; then
        > $HOME/.todo
    elif [[ "$1" == "-r" ]]; then
        nl -b a "$HOME/.todo"
        eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}; echo
        read -p "Type a number to remove: " number
        sed -i ${number}d $HOME/.todo "$HOME/.todo"
    else
        printf "%s\n" "$*" >> "$HOME/.todo"
    fi
}

ipif() {
    if grep -P "(([0-9]\d{0,2})\.){3}(?2)" <<< "$1"
    then
        curl -l ipinfo.io/"$1"
    else
        local ipadd=$(host "$1") &&
        local ipawk=$(awk '{ print $4 }' <<< "$ipadd")
        curl ipinfo.io/"$ipawk"
    fi
    echo
}

#Now open a terminal and just do:
#secure_chromium
function secure_chromium {
    port=1080
    #使用以下两种配置都可以
    #export SOCKS_SERVER=localhost:$port
    #export SOCKS_VERSION=5
    #chromium &
    chromium --proxy-server="socks://localhost:$port" &
    exit
}

# help url:https://wiki.archlinux.org/index.php/Kernel_modules_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)  显示所有内核参数的脚本
function aa_mod_parameters ()
{
    N=/dev/null;
    C=`tput op` O=$(echo -en "\n`tput setaf 2`>>> `tput op`");
    for mod in $(cat /proc/modules|cut -d" " -f1);
    do
        md=/sys/module/$mod/parameters;
        [[ ! -d $md ]] && continue;
        m=$mod;
        d=`modinfo -d $m 2>$N | tr "\n" "\t"`;
        echo -en "$O$m$C";
        [[ ${#d} -gt 0 ]] && echo -n " - $d";
        echo;
        for mc in $(cd $md; echo *);
        do
            de=`modinfo -p $mod 2>$N | grep ^$mc 2>$N|sed "s/^$mc=//" 2>$N`;
            echo -en "\t$mc=`cat $md/$mc 2>$N`";
            [[ ${#de} -gt 1 ]] && echo -en " - $de";
            echo;
        done;
    done
}

function randpw32(){ < /dev/urandom tr -dc '!@#$%^&*'_A-Z-a-z-0-9 | head -c${1:-32};echo; }

function randpw16(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo; }

function randhcj(){
    var=`echo $1 | sha512sum | awk '{print $1}'`
    hcj="*${var:66:6}%${var:77:7}@"
    echo ${hcj}
    echo
}

# pacman
#help url https://wiki.archlinux.org/index.php/Pacman_tips#Shortcuts
pacman-size()
{
    CMD="pacman -Si"
    SEP=": "
    TOTAL_SIZE=0

    RESULT=$(eval "${CMD} $@ 2>/dev/null" | awk -F "$SEP" -v filter="Size" -v pkg="^Name" \
      '$0 ~ pkg {pkgname=$2} $0 ~ filter {gsub(/\..*/,"") ; printf("%6s KiB %s\n", $2, pkgname)}' | sort -u -k3)

    echo "$RESULT"

    ## Print total size.
    echo "$RESULT" | awk '{TOTAL=$1+TOTAL} END {printf("Total : %d KiB\n",TOTAL)}'
}

dclean() {
    processes=`docker ps -q -f status=exited`
    if [ -n "$processes" ]; then
      echo $processes | xargs docker rm
    fi

    images=`docker images -q -f dangling=true`
    if [ -n "$images" ]; then
      echo $images | xargs docker rmi
    fi
}

dcleanlaradock() {
	echo 'Removing ALL containers associated with laradock'
	docker ps -a | awk '{ print $1,$2 }' | grep laradock | awk '{print $1}' | xargs -I {} docker rm {}

	# remove ALL images associated with laradock_
	# does NOT delete laradock/* which are hub images
	echo 'Removing ALL images associated with laradock_'
	docker images | awk '{print $1,$2,$3}' | grep laradock_ | awk '{print $3}' | xargs -I {} docker rmi {}

	echo 'Listing all laradock docker hub images...'
	docker images | grep laradock

	echo 'dcleanlaradock completed'
}

wttr()
{
  local localt=$(file /etc/localtime 2>/dev/null | awk -F'/' '{print $NF}')
  local request="wttr.in/${localt:-Shanghai}"
  [ "$(tput cols)" -lt 125 ] && request+='?0qnmMA'
  curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}

# Define `setproxy` command to enable proxy configuration
setproxy() {
  export http_proxy="http://localhost:1080"
  export https_proxy="http://localhost:1080"
}

# Define `unsetproxy` command to disable proxy configuration
unsetproxy() {
  unset http_proxy
  unset https_proxy
}

# By default, enable proxy configuration for terminal login
[ -z "$(ss -tlnp | grep 1080)" ] || setproxy

unlockbw() {
  export BW_SESSION="$(bw unlock --raw)"
}

function whatwhen () {
    emulate -L zsh
    local usage help ident format_l format_s first_char remain first last
    usage='USAGE: whatwhen [options] <searchstring> <search range>'
    help='Use `whatwhen -h'\'' for further explanations.'
    ident=${(l,${#${:-Usage: }},, ,)}
    format_l="${ident}%s\t\t\t%s\n"
    format_s="${format_l//(\\t)##/\\t}"
    # Make the first char of the word to search for case
    # insensitive; e.g. [aA]
    first_char=[${(L)1[1]}${(U)1[1]}]
    remain=${1[2,-1]}
    # Default search range is `-100'.
    first=${2:-\-100}
    # Optional, just used for `<first> <last>' given.
    last=$3
    case $1 in
        ("")
            printf '%s\n\n' 'ERROR: No search string specified. Aborting.'
            printf '%s\n%s\n\n' ${usage} ${help} && return 1
        ;;
        (-h)
            printf '%s\n\n' ${usage}
            print 'OPTIONS:'
            printf $format_l '-h' 'show help text'
            print '\f'
            print 'SEARCH RANGE:'
            printf $format_l "'0'" 'the whole history,'
            printf $format_l '-<n>' 'offset to the current history number; (default: -100)'
            printf $format_s '<[-]first> [<last>]' 'just searching within a give range'
            printf '\n%s\n' 'EXAMPLES:'
            printf ${format_l/(\\t)/} 'whatwhen grml' '# Range is set to -100 by default.'
            printf $format_l 'whatwhen zsh -250'
            printf $format_l 'whatwhen foo 1 99'
        ;;
        (\?)
            printf '%s\n%s\n\n' ${usage} ${help} && return 1
        ;;
        (*)
            # -l list results on stout rather than invoking $EDITOR.
            # -i Print dates as in YYYY-MM-DD.
            # -m Search for a - quoted - pattern within the history.
            fc -li -m "*${first_char}${remain}*" $first $last
        ;;
    esac
}

# Create small urls via http://goo.gl using curl(1).
# API reference: https://code.google.com/apis/urlshortener/
function zurl () {
    emulate -L zsh
    setopt extended_glob

    if [[ -z $1 ]]; then
        print "USAGE: zurl <URL>"
        return 1
    fi

    local PN url prog api json contenttype item
    local -a data
    PN=$0
    url=$1

    # Prepend 'http://' to given URL where necessary for later output.
    if [[ ${url} != http(s|)://* ]]; then
        url='http://'${url}
    fi

    if check_com -c curl; then
        prog=curl
    else
        print "curl is not available, but mandatory for ${PN}. Aborting."
        return 1
    fi
    api='https://www.googleapis.com/urlshortener/v1/url'
    contenttype="Content-Type: application/json"
    json="{\"longUrl\": \"${url}\"}"
    data=(${(f)"$($prog --silent -H ${contenttype} -d ${json} $api)"})
    # Parse the response
    for item in "${data[@]}"; do
        case "$item" in
            ' '#'"id":'*)
                item=${item#*: \"}
                item=${item%\",*}
                printf '%s\n' "$item"
                return 0
                ;;
        esac
    done
    return 1
}

# mercurial related stuff
if check_com -c hg ; then
    # gnu like diff for mercurial
    # http://www.selenic.com/mercurial/wiki/index.cgi/TipsAndTricks
    #f5# GNU like diff for mercurial
    function hgdi () {
        emulate -L zsh
        local i
        for i in $(hg status -marn "$@") ; diff -ubwd <(hg cat "$i") "$i"
    }

    # build debian package
    #a2# Alias for \kbd{hg-buildpackage}
    alias hbp='hg-buildpackage'

    # execute commands on the versioned patch-queue from the current repos
    [[ -n "$GRML_NO_SMALL_ALIASES" ]] || alias mq='hg -R $(readlink -f $(hg root)/.hg/patches)'

    # diffstat for specific version of a mercurial repository
    #   hgstat      => display diffstat between last revision and tip
    #   hgstat 1234 => display diffstat between revision 1234 and tip
    #f5# Diffstat for specific version of a mercurial repos
    function hgstat () {
        emulate -L zsh
        [[ -n "$1" ]] && hg diff -r $1 -r tip | diffstat || hg export tip | diffstat
    }

fi # end of check whether we have the 'hg'-executable

# dirstack handling

DIRSTACKSIZE=${DIRSTACKSIZE:-10}
DIRSTACKFILE=${DIRSTACKFILE:-${ZDOTDIR:-${HOME}}/.zdirs}

if zstyle -T ':grml:chpwd:dirstack' enable; then
    typeset -gaU GRML_PERSISTENT_DIRSTACK
    function grml_dirstack_filter () {
        local -a exclude
        local filter entry
        if zstyle -s ':grml:chpwd:dirstack' filter filter; then
            $filter $1 && return 0
        fi
        if zstyle -a ':grml:chpwd:dirstack' exclude exclude; then
            for entry in "${exclude[@]}"; do
                [[ $1 == ${~entry} ]] && return 0
            done
        fi
        return 1
    }

    function chpwd () {
        (( ZSH_SUBSHELL )) && return
        (( $DIRSTACKSIZE <= 0 )) && return
        [[ -z $DIRSTACKFILE ]] && return
        grml_dirstack_filter $PWD && return
        GRML_PERSISTENT_DIRSTACK=(
            $PWD "${(@)GRML_PERSISTENT_DIRSTACK[1,$DIRSTACKSIZE]}"
        )
        builtin print -l ${GRML_PERSISTENT_DIRSTACK} >! ${DIRSTACKFILE}
    }

    if [[ -f ${DIRSTACKFILE} ]]; then
        # Enabling NULL_GLOB via (N) weeds out any non-existing
        # directories from the saved dir-stack file.
        dirstack=( ${(f)"$(< $DIRSTACKFILE)"}(N) )
        # "cd -" won't work after login by just setting $OLDPWD, so
        [[ -d $dirstack[1] ]] && cd -q $dirstack[1] && cd -q $OLDPWD
    fi

    if zstyle -t ':grml:chpwd:dirstack' filter-on-load; then
        for i in "${dirstack[@]}"; do
            if ! grml_dirstack_filter "$i"; then
                GRML_PERSISTENT_DIRSTACK=(
                    "${GRML_PERSISTENT_DIRSTACK[@]}"
                    $i
                )
            fi
        done
    else
        GRML_PERSISTENT_DIRSTACK=( "${dirstack[@]}" )
    fi
fi
