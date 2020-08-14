#!/usr/bin/env bash
# Time: 2020-04-15 17:17:31
# 本脚本只有反向代理功能,且服务端还要做nginx映射监听端口到所有主机
#
# 参考： https://blog.csdn.net/u012843189/article/details/79522738
# 反向代理 ssh -fCNR 例子：ssh -fCNR [B机器IP或省略]:[B机器端口]:[A机器的IP]:[A机器的sshd端口] [登录B机器的用户名@B机器的IP] -p [B机器的sshd端口]
# 正向代理 ssh -fCNL 例子：ssh -fCNL [*或省略]:[A机器端口]:[B机器的IP]:[B机器端口] [登录B机器的用户名@B机器的IP] -p [B机器的sshd端口]
#-f 后台执行ssh指令
#-C 允许压缩数据
#-N 不执行远程指令
#-R port:host:hostport 将远程主机(服务器)的某个端口转发到本地主机指定的端口,远程主机上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转向出去, 同时本地主机和 host 的 hostport 端口建立连接. 
#-L port:host:hostport 将本地机(客户机)的某个端口转发到远端指定机器的指定端口，本地机器上分配了一个 socket 侦听 port 端口, 一旦这个端口上有了连接, 该连接就经过安全通道转发出去, 同时远程主机和 host 的 hostport 端口建立连接. 
#-p 指定远程主机的端口

USAGE () {
  echo "Usage:"
  echo "  bash autossh-do.sh [options...] <arg>"
  echo "Options:"
  echo "  -p	The remot host listen port"
  echo "  -l	The local host listen port"
  echo "  -h	The remot host who is proxy service"
  echo " Example: bash autossh-do.sh -p 2222 -l 22 -h test.host.com"
}

if [ $# -lt 4 ]; then
  USAGE
  exit -1
fi

while getopts "ap:l:h:" OPT; do
  case $OPT in
    p)
      REMOTE_PORT=$OPTARG
      ;;
    l)
      LOCAL_PORT=$OPTARG
      ;;
    h)
      REMOTE_HOST=$OPTARG
      ;;
    :)
      USAGE
      exit -1
      ;;
    *)
      USAGE
      exit -1
      ;;
    ?)
      USAGE
      exit -1
      ;;
  esac
done

manage_port=`expr ${REMOTE_PORT} + 1`

autossh -M ${manage_port} \
  -o "PasswordAuthentication=no" \
  -o "PubkeyAuthentication=yes" \
  -o "StrictHostKeyChecking=false" \
  -o "ServerAliveInterval 60" \
  -o "ServerAliveCountMax 3" \
  -fCNR ${REMOTE_PORT}:localhost:${LOCAL_PORT} \
  ${REMOTE_HOST}
