#!/usr/bin/env bash

warning=85
critical=95

# Detect slash FSType
fstype=$(df -l "$1" --output=fstype | sed 1d)

# Set query cmd
if [[ -z "$fstype" ]]
then
  exit
elif [[ "$fstype" == zfs ]]
then
  zfsroot=$(echo $1 | sed 's:/.*::')
  pcent=$(zpool list -o cap -H $zfsroot | tr -d '%')
else
  pcent=$(df "$1" --output="pcent" 2>/dev/null | sed 1d | tr -d ' ' | tr -d '%')
fi

json_fmt='{"text": "%s" , "class": "%s" }\n'

if [[ -z $pcent ]]
then
    echo -e "Usage: ./storage.sh [mountpoint]\nexemple : ./storage.sh /"
else
    if [[ $pcent -lt $warning ]]
    then
        printf "$json_fmt" "$pcent" "normal"
    elif [[ $pcent -ge $warning ]] && [[ $pcent -lt $critical ]]
    then
        printf "$json_fmt" "$pcent" "warning"
    elif [[ $pcent -ge $critical ]]
    then
      printf "$json_fmt" "$pcent" "critical"
    fi
fi
