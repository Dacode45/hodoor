#!/bin/bash

case "$1" in
start)
  ssh -nNT -R 8081:localhost:8081 ubuntu@ec2-54-213-198-191.us-west-2.compute.amazonaws.com -i "/home/pi/.ssh/cse521.pem" &
  iptables -I INPUT -p tcp --dport 8081 --syn -j ACCEPT
  echo $1>/var/run/ssh.pid
stop)
  kill `cat /var/run/ssh.pid`
  rm /var/run/ssh.pid
  ;;
restart)
  $0 stop
  $0 start
  ;;
status)
  if [ -e /var/run/ssh.pid]; then
    echo ssh tunnel is running, pid=`cat /var/run/ssh.pid`
  else
    echo ssh tunnel is not runnint
    exit 1;
  fi
  ;;
*)
  echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0
