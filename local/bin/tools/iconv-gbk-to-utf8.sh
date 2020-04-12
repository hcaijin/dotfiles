#!/usr/bin/env bash
# iconv-gbk-to-utf8.sh ./ *.java
# Time: 2020-04-09 14:20:37
if [ "$#" != "2" ]; then
  echo "Usage: `basename $0` dir filter"
  exit
fi
dir=$1
filter=$2
# echo $1
for file in `find $dir -type f -name "$filter"`; do
  file $file | grep -i 'utf-8' > /dev/null
  if [ $? != 0 ]; then
    # enca -L zh_CN $file
    iconv -f gb2312 -t utf8 -c -o $file $file
  fi
done
