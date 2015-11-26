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
    * Consul Template will automatically rewrite the NGINX config and restart it whenever a container is started or stopped, as notified by Registrator (I think).

## Low-level steps
See the steps [here](./STEPS.md).

## Conclusions

0. Figuring out the commands to bootstrap the Consul cluster took the most trial-and-error. This is mainly because the docs are a bit of a mess, and I was confused between `progrium/consul`, `gliderlabs/consul` and the `master` vs `legacy` branches on github, as well as unclear tagging of their respective Docker images. I eventually settled on using `gliderlabs/consul:legacy` for this demo.

0. Once the one-time setup is done, this is amazing. Consul web UI shows what services are registered (for sanity checking), and you can tail the output of the load balancer host to see containers as they come up, with an imperceptibly small delay.

0. The final test of this POC will be to see whether this simplifies our configuration of multiple staging environments in a meaningful way.
