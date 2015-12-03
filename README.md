# docker-staging-env-poc
[POC] Scalable, Automatic Docker Container Service Discovery and (TODO: Deployment) to a Staging env

## References
* http://jlordiales.me/2015/02/03/registrator/
* http://jlordiales.me/2015/04/01/consul-template/
* http://www.maori.geek.nz/scalable_architecture_dr_con_docker_registrator_consul_nginx/

## Overview
* We'll bring up 3 generic Docker nodes: `host-1`, `host-2` and `host-3`.
    * Host 1 and 2 represent nodes that will house application containers, while 3 will serve as our load balancer.
* On host 1 and 2, we'll start Consul, Registrator, and any microservice containers.
    * Consul provides a simple K-V store of the IPs and ports of whatever we tell it.
    * Registrator provides automatic registering of newly "upped" containers to Consul, and also automatically deregisters them when they are killed.
* On host 3, we'll start Consul, NGINX and Consul Template.
    * NGINX provides a simple load balancing solution, i.e. `$ curl http://loadbalancerforservice` should automatically round-robin between the app containers on host 1 and 2.
    * Consul Template will automatically rewrite the NGINX config and restart it whenever a container is started or stopped, as Registrator updates Consul's K-V store.

## Usage

0. Bring up the Docker hosts & Consul cluster

    ```
    vagrant up
    ```

    Then view the Consul web UI at http://192.168.50.101:8500

0. In another terminal window, start issuing a stream of requests against the load balancer

    ```
    while sleep 1; do curl http://192.168.50.103; done
    ```

0. Deploy the app

    ```
    maestro status # works
    maestro pull && maestro restart # TODO: fix this
    ```

## Granular steps
See the steps [here](./STEPS.md).

## Takeaways

0. Figuring out the commands to bootstrap the Consul cluster took the most trial-and-error. This is mainly because the docs are a bit of a mess, and I was confused between `progrium/consul`, `gliderlabs/consul` and the `master` vs `legacy` branches on github, as well as unclear tagging of their respective Docker images. I eventually settled on using `gliderlabs/consul:legacy` for this demo.

0. Once the one-time setup is done, this is amazing. Consul web UI shows what services are registered (for sanity checking), and you can tail the output of the load balancer host to see containers as they come up, with an imperceptibly small delay.

0. Enabling app containers to be launched on any random port (instead of hardcoding it and carefully avoiding port conflicts with any other containers that happen to reside on the same host) is huge. This gets us closer to treating containers like "cattle" instead of "kittens."

0. Consul is responsible for checking container health (which is a lot simpler than configuring the load balancer to do the same), and because of Registrator, it essentially updates in realtime, so even if a container dies, the load balancer shouldn't drop a single request.

0. I've only scratched the surface of Consul Template's [capabilities](https://hashicorp.com/blog/introducing-consul-template.html). If done right, we can make configs completely dynamic, and Consul Template can even execute an arbitrary bash command (reload nginx, or the application) when configs change.

0. The final test of this POC will be to see whether this simplifies our configuration of multiple staging environments in a meaningful way.
