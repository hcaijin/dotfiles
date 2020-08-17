#!/usr/bin/env bash
# Time: 2020-08-17 12:27:10
iplink=$(ip link | grep -i ',up,' | grep -E 'wlp|enp' | awk '{print $2}')
BLOCK_INSTANCE=${iplink:0:-1}
INTERFACE="${BLOCK_INSTANCE:-wlp5s0}"
SEND_HEADER="📶 Network Module"
MYIPFILE=/tmp/myip.txt
MYPIPFILE=/tmp/myproxyip.txt
show_ip_str="<b><span color=\"green\">Show IP Address >>></span></b>"

function getIpStr(){
  ESSID=$(/sbin/iwconfig $INTERFACE | grep 'ESSID:' | awk '{print $4}')
  show_ip_str+="\n- ${ESSID}"
  ip=$(ip address show $INTERFACE | grep 'inet ' | awk '{print $2}'); [ $? == 0 ] || {
    ip="Pls check your network."
    rm ${MYIPFILE} >/dev/null
    rm ${MYPIPFILE} >/dev/null
  }
  show_ip_str+="\n- Local IP:\"${ip}\""
  if [ $ip != "Pls check your NetworkManager." ]
  then
    pubip=$(cat ${MYIPFILE} 2>/dev/null)
    if [ "$pubip" != "" ]
    then
      show_ip_str+="\n- Public IP:\"${pubip}\""
    else
      curl myip.ipip.net 1>${MYIPFILE} 2>/dev/null; [ $? == 0 ] || rm ${MYIPFILE} >/dev/null
      pubip=$(cat ${MYIPFILE} 2>/dev/null)
      show_ip_str+="\n- Public IP:\"${pubip:-Pls check your public network.}\""
    fi
    proxyip=$(cat ${MYPIPFILE} 2>/dev/null)
    if [ "$proxyip" != "" ]
    then
      show_ip_str+="\n- Proxy IP:\"${proxyip}\""
    else
      ss -tlnp | grep '127.0.0.1:1080' >/dev/null && proxy="--socks5 127.0.0.1:1080"
      if [ -z "$proxy" ]
      then
        ipinfo=$(curl  -H "Accept: application/json" ipinfo.io/json 2>/dev/null)
        if [[ $? == 0 ]]; then
          ip=$(echo $ipinfo | jq -r ".ip")
          city=$(echo $ipinfo | jq -r ".city")
          country=$(echo $ipinfo | jq -r ".country")
          echo "当前 IP：${ip}  来自于：${country} ${city}    " > ${MYPIPFILE} 2>/dev/null
          proxyip=$(cat ${MYPIPFILE} 2>/dev/null)
          show_ip_str+="\n- Proxy IP:\"${proxyip:-Pls check your proxy network.}\""
        else
          rm ${MYPIPFILE} >/dev/null
        fi
      else
        curl -s ${proxy} myip.ipip.net 1>${MYPIPFILE} 2>/dev/null; [ $? == 0 ] || rm ${MYPIPFILE} >/dev/null
        proxyip=$(cat ${MYPIPFILE} 2>/dev/null)
        show_ip_str+="\n- Proxy IP:\n${proxyip:-Pls check your proxy network.}"
      fi
    fi
  fi
}

if [ "${1}" == "rm" ]
then
  rm ${MYIPFILE} >/dev/null
  rm ${MYPIPFILE} >/dev/null
fi

getIpStr
notify-check-send "$SEND_HEADER" "$show_ip_str"
