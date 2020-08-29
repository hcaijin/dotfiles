#!/usr/bin/env bash
# Time: 2020-08-29 22:53:17

pgrep -x wofi && exit

swaymsg -t get_tree |
         jq -r '.nodes[].nodes[] | if .nodes then [recurse(.nodes[])] else [] end + .floating_nodes
       | .[] | select(.nodes==[]) | ((.id | tostring) + " " + .name)' |
         wofi --show dmenu -i -p "Window:" -L 10 | {
           read -r id name
           swaymsg "[con_id=$id]" focus
       }
