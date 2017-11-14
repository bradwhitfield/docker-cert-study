# Probably Start Here

https://docs.docker.com/get-started/

# Locking the Cluster

* Feature was released in support of Docker secrets.
* I think the they use to lock the cluster key is used to decyrpt the Mutual TLS and Raft log encryption keys.
* You do not need the unlock-key to join a new manager - I tested to confirm this.

## Something Like this

```bash
docker swarm init --autolock
systemctl restart docker
docker swarm unlock
# Enter the key when prompted

# View the key with this from a manager node
docker swarm unlock-key

# Rotate the unlock key with this form a manager
docker swarm unlock-key --rotate
```

# Convert to compose for stacks and such

## DAB Files

Never heard of this [DAB file stuff](https://docs.docker.com/compose/bundles/#overview). I suspect
this wont' be any sort of focus on the exam.

* These are now fully support but "The concept of a `bundle` is not the emphasis for new releases going forward."
* A stack file is a particular type of v3 compose file.
* These are for maintain multi-service applications.
* Still experimental?
* Basically a compilation of services.

## Service Files

Should probably explore volumes more.

* version 3 of compose only allows deploying pre-built images when running deploy stack.
* build context can be a github repo.

# Diagnose Broken services

Re-read this later.

https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/#pending-services

and probably this

https://docs.docker.com/engine/swarm/services/

# Automated Builds

Although not part of the exam, I wanted to set this up anyways. Dockers main documentation for this
was incorrect in saying you could select limited access. I was able to setup the builds following
any older piece of [documentation](https://docs.docker.com/docker-hub/builds/#remote-build-triggers) I found on there site.

# Sketch how a Dockerized application communicates with legacy systems

Probably re-read this: https://docs.docker.com/engine/userguide/networking/default_network/container-communication/

Essentially you need to understand how iptables will route and block traffic to/from containers, and how Docker
can manage iptables for you.

# Paraphrase the importance of quorum in a swarm cluster

From the docs:

```
An unreachable health status means that this particular manager node is unreachable from other manager nodes. In this case you need to take action to restore the unreachable manager:

* Restart the daemon and see if the manager comes back as reachable.
* Reboot the machine.
* If neither restarting or rebooting work, you should add another manager node or promote a worker to be a manager node. You also need to cleanly remove the failed node entry from the manager set with docker node demote <NODE> and docker node rm <id-node>.
```

That seems awfully painful that it won't clean up nodes after a while...

Probably wouldn't hurt to run through a backup and recovery process manually.

## Practice Backup

```
terraform apply -var backup=true
gcloud compute ssh --zone "us-east1-b" manager1
curl 169.254.169.254/0.1/meta-data/attributes/startup-script -o startup.sh && chmod +x startup.sh && ./startup.sh
docker service create --name nginx --replicas 2 -p 80:80 nginx
docker service ls
sudo tar -zcvf swarm.tar.gz /var/lib/docker/swarm/ # Note this is a hot backup
sudo chown $USER:$USER swarm.tar.gz
exit
gcloud compute scp --zone "us-east1-b" manager1:~/swarm.tar.gz .
gcloud compute scp --zone "us-east1-b" swarm.tar.gz manager1-bak:~/swarm.tar.gz
gcloud compute instances stop --zone us-east1-b manager1
gcloud compute ssh --zone "us-east1-b" manager1-bak
sudo systemctl stop docker
sudo mkdir -p /var/lib/docker/swarm
sudo tar -xvf swarm.tar.gz -C /
sudo systemctl start docker
docker swarm init --force-new-cluster # Note that it will spit out the old managers IP in the join command.
docker service ls
docker node rm $(docker node ls -q -f "role=node")
docker -h node1-ip:2375 swarm join --token $(docker swarm join-token -q worker) $COREOS_PRIVATE_IPV4:2377
docker -h node2-ip:2375 swarm join --token $(docker swarm join-token -q worker) $COREOS_PRIVATE_IPV4:2377
docker node ls
exit
terraform destroy
```
