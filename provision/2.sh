#!/bin/bash

# used by registrator
export HOST_IP=$(ifconfig enp0s8 | grep 'inet ' | awk '{ print $2  }')

# TODO: add 'sleep until leader is up' logic, if needed?

# join existing consul cluster
$(docker run --restart=always gliderlabs/consul:legacy cmd:run $HOST_IP:192.168.50.101 -d -v /mnt:/data)

# start registrator
docker run --restart=always -d --name=registrator --net=host --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator:latest consul://$HOST_IP:8500
