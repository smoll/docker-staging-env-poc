# docker-staging-env-poc

[POC] Automatic Docker Container Service Discovery and (TODO: Deployment) to a Staging env

## References
* http://jlordiales.me/2015/02/03/registrator/
* http://jlordiales.me/2015/04/01/consul-template/
* http://www.maori.geek.nz/scalable_architecture_dr_con_docker_registrator_consul_nginx/

## Overview

* We'll bring up 3 generic Docker nodes: `host-1`, `host-2` and `host-3`.
    * Host 1 and 2 represent nodes that will house application containers, while 3 will serve as our load balancer.
* On host 1 and 2, we'll start Consul and Registrator (and also the microservice containers).
    * Consul provides a simple K-V store of the IPs and ports of whatever we tell it.
    * Registrator provides automatic registering of newly "upped" containers to Consul, and also automatically deregisters them when they are killed.
* On host 3, we'll start NGINX and Consul Template.
    * NGINX provides a simple load balancing solution, i.e. `$ curl http://loadbalancerip/myapp` should automatically round-robin between the containers on host 1 and 2.
    * Consul Template will automatically rewrite the NGINX config and restart it whenever a container is started or stopped, as notified by Registrator (I think).

## Steps

### One-time setup

0. Bring up vagrant machines (generic Docker hosts)

    ```
    $ vagrant up
    $ vagrant status
    ```

0. SSH into each machine (`host-1`, `host-2`, `host-3`) and verify they each have a unique IP address in the private network

    ```
    $ vagrant ssh host-1

    host-1$ ifconfig enp0s8 | grep 'inet ' | awk '{ print $2 }'

    172.28.128.3
    ```

0. On `host-1`, start Consul and Registrator

    ```bash
    host-1$ DOCKER_IP=$(ifconfig enp0s8 | grep 'inet ' | awk '{ print $2 }')

    # start consul
    host-1$ docker run -d -h node -p 8500:8500 -p 53:53/udp progrium/consul -server -bootstrap -advertise $DOCKER_IP

    # start registrator
    host-1$ docker run -d --name=registrator --net=host --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator:latest consul://localhost:8500

    # check everything is up
    host-1$ docker ps

    CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS                                                                                                            NAMES
    a33d20734dce        gliderlabs/registrator:latest   "/bin/registrator co   26 minutes ago      Up 26 minutes                                                                                                                        registrator
    fd3e7cd43f38        progrium/consul:latest          "/bin/start -server    27 minutes ago      Up 27 minutes       8302/tcp, 8400/tcp, 8300/tcp, 8301/udp, 53/tcp, 8301/tcp, 8302/udp, 0.0.0.0:53->53/udp, 0.0.0.0:8500->8500/tcp   berserk_hawking
    ```

    do the exact same thing on `host-2`.

0. On `host-3`, start Consul and the DR-CoN container

    ```
    $ vagrant ssh host-3

    host-3$ DOCKER_IP=$(ifconfig enp0s8 | grep 'inet ' | awk '{ print $2 }')

    host-3$ echo $DOCKER_IP

    172.28.128.5

    # start consul
    host-3$ docker run -d -h node -p 8500:8500 -p 53:53/udp progrium/consul -server -bootstrap -advertise $DOCKER_IP

    # start nginx & consul template
    host-3$ docker run -it -e "CONSUL=$DOCKER_IP:8500" -e "SERVICE=simple" -p 80:80 smoll/dr-con
    ```

### On every deploy

0. On `host-1`, let's bring up one instance of the microservice, naming it `simple`, on a random port (note the `-P`). In practice, this can be easily automated with Centurion or MaestroNG.

    ```
    host-1$ docker run -d -e "SERVICE_NAME=simple" -P smoll/flask-nanoservice

    host-1$ docker port 9adcffb51d1c

    5000/tcp -> 0.0.0.0:49153
    ```

    Note that within the private network I can now hit this service on the ephemeral port:

    ```
    $ curl http://172.28.128.3:49153

    Hello World from 9adcffb51d1c
    ```

    This isn't publicly accessible on the Internet, though.

0. The load balancer should now know about the container on `host-1`.

    ```

    ```

0. Bring up a second instance of the microservice on `host-2`.

0. The load balancer should now round-robin between the two containers.
