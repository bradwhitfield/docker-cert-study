#!/bin/bash
docker swarm init --advertise-addr $COREOS_PRIVATE_IPV4
docker -H ${node1_ip}:2375 swarm join --token $(docker swarm join-token -q worker) $COREOS_PRIVATE_IPV4:2377
docker -H ${node2_ip}:2375 swarm join --token $(docker swarm join-token -q worker) $COREOS_PRIVATE_IPV4:2377
docker -H ${node3_ip}:2375 swarm join --token $(docker swarm join-token -q worker) $COREOS_PRIVATE_IPV4:2377
