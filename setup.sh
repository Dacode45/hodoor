[Unit]
Description=Hodoor Service

[Service]
Type=simple
ExecStartPre=/sbin/iptables -I INPUT -p tcp --dport 8081 --syn -j ACCEPT
ExecStart=/usr/bin/ssh -nNT -R 8081:localhost:8081 ubuntu@ec2-54-213-198-191.us-west-2.compute.amazonaws.com -i "/home/pi/.ssh/cse521.pem"
Restart=on-failure

[Install]
WantedBy=multi-user.target
