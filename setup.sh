#!/bin/bash
ssh -nNT -R 8081:localhost:8081 ubuntu@ec2-54-213-198-191.us-west-2.compute.amazonaws.com -i "/home/pi/.ssh/cse521.pem" &
echo "ssh setup"
source /home/pi/hodoor/pi.env
echo "pi env setup"
sudo iptables -I INPUT -p tcp --dport 8081 --syn -j ACCEPT
echo "iptables setup"
sudo -E node /var/www/html/index.js &
echo "server running"
