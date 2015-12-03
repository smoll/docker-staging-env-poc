#!/bin/bash

# used by registrator
export HOST_IP=192.168.50.101

# lead consul cluster
$(docker run --restart=always gliderlabs/consul:legacy cmd:run 192.168.50.101 -d -v /mnt:/data)

# start registrator
docker run --restart=always -d --name=registrator --net=host --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator:latest consul://$HOST_IP:8500
