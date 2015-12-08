#!/bin/bash

# used by dr-con
export HOST_IP=$(ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

# start nginx + consul template
docker run --restart=always -d -e "CONSUL=$HOST_IP:8500" -e "SERVICE=flask-nanoservice" -p 80:80 smoll/dr-con:latest
