#!/bin/sh
echo "======== docker containers logs file size ========"
logs=$(find ${HOME}/var/lib/docker/containers/ -name *-json.log)
for log in $logs
do
  ls -lh $log
  cat /dev/null > $log
done
