#!/usr/bin/bash


# change port to 2003

if command -v sed &> /dev/null && command -v ufw &> /dev/null; then
    sed -i 's/#Port 22/Port 2003/' /etc/ssh/sshd_config
    ufw delete allow 22/tcp ; ufw delete allow 22/udp ; ufw delete allow 22 ; ufw allow 2003 ;ufw reload
    service sshd restart
else
    echo "either sed or ufw (or both) does not exist!"
fi


