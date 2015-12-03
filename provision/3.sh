#!/bin/bash

# used by dr-con
export HOST_IP=$(ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

# join existing consul cluster
$(docker run --restart=always gliderlabs/consul:legacy cmd:run $HOST_IP:192.168.50.101 -d -v /mnt:/data)

# start nginx + consul template
docker run --restart=always -d -e "CONSUL=$HOST_IP:8500" -e "SERVICE=flask-nanoservice" -p 80:80 smoll/dr-con:latest
