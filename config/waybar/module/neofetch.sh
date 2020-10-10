#!/usr/bin/env bash

FETCHLOG="${XDG_CACHE_HOME:-$HOME/.cache}/neofetch.log"

[ -f "$FETCHLOG" ] || neofetch > $FETCHLOG

printf "%s" $(cat $FETCHLOG | grep 'OS' | awk '{print $2$3}')
