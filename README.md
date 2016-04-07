# Swarm Demo

This is a simple demo of a Swarm cluster running in a vagrant environment with to OpenSuse VMs containing a swarm agent. It assumes there is docker client installed in the host machine.

This demo deploys a dummy web application over a swarm cluster. The webapp requires a db which is set up and running over a dedicated container, so the cluster, once deployed, will contain two docker containers (node0 and node1) out of the box. 

# Deployment

This demo also starts up two containers in the cluster so it uses the local docker client with the DOCKER_HOST environment variable pointing to the swarm manager agent (node0 IP in this case). This is relevant as it forces you to run vagrant machines one by one *vagrant up*, without any machine parameter cannot be used, as it checks the docker client before starting the process and at that time, there is no swarm manager container running yet. So the deployment must be done **starting machines one by one**:

```
$ vagrant up node1
$ vagrant up node0
$ vagrant up db
$ vagrant up webapp
```

It might take quite long as the base VM of opensuse might be donwloaded during the process and because once the machie is provided it start provision docker and building images inside it (only the first boot). So it will take a while.

Once done you have a cluster set and running. Test it from your host docker installation by running the following commands:

```
$ docker -H tcp://192.168.56.200:23755 info
```
To list the current cluster nodes and some status information. Or:
```
$ docker -H tcp://192.168.56.200:23755 ps
```
To list the current containers running in the cluster, which should be the *db* and *webapp* containers. 

Finally check the webapp is running by pointing the browser to *http://\<node_IP_running_webapp\>:3000*, where *\<node_IP_running_webapp\>* will be node0 IP (192.168.56.200) or node1 IP (192.168.56.201). Use *docker ps* command over the swarm manager to verify in which node is currently running the webapp.


