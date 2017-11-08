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
