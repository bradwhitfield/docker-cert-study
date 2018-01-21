# Describe Dockerfile options

## Parser Directives

Didn't know these existed, although there is only one right now.

https://docs.docker.com/engine/reference/builder/#escape

# Docker Image Command

The format and filter commands are kind of cool. I've never really played with them much before now.

```bash
# Some random-ish examples
docker images --filter=reference='*/*:latest' --format "table {{.ID}}\t{{.Repository}}:{{.Tag}}\t{{.CreatedAt}}"
docker images --filter=reference='bradwhitfield/*:latest' --format "{{.ID}}\t{{.Repository}}:{{.Tag}}"
```

A couple of commands to note that now (or maybe always) have the images command as a parent.

```bash
docker image build # `docker build`
docker image history # `docker history`
docker image ls # `docker images`
docker image pull # `docker pull`
docker image push # `docker push`
docker image rm # `docker rmi`
docker image tag # `docker tag`
docker image save # `docker save`
docker image load # `docker load`
docker image import # `docker import`
docker image inspect # `docker inspect` when specifying an image ID or name that doesn't
# overlap with a container (container appears to be default)
```

## Deploying a Registry

When following this guide, note that the port mapping is wrong. It should be `443`
instead of 80 since it's HTTPS.

Bash for create the testing insecure registry testing.

```bash
# On my computer
terraform apply # in `docker-cert-study/orchestration/swarm-cluster/`
# Note this is the pathing for WSL.
gcloud compute scp --zone "us-east1-b" /mnt/c/Users/bradw/projects/docker-cert-study/image/docker-compose.yml manager1:~/docker-compose.yml # in `docker-cert-study/images/`
# On manager1 once created
openssl req \
       -newkey rsa:2048 -nodes -keyout registry.key \
       -x509 -days 365 -out registry.crt
docker secret create registry.key registry.key
docker secret create registry.crt registry.crt
docker run --entrypoint htpasswd registry:2 -Bbn brad something > htpasswd
docker secret create htpasswd htpasswd
docker stack deploy -c docker-compose.yml registry
```

## Content Trust

Essentially this is just opt-in signing for container versions.

Require Docker Content Trust with `export DOCKER_CONTENT_TRUST=1` and Docker will only work with signed tags.
To bypass for one command execution, you can pass the `--disable-content-trust` flag to the CLI.

To sign an image, have the `DOCKER_CONTENT_TRUST` set, issue a `docker push`. This will have Docker generate
a root certificate for you, and store it in ~/.docker/trust registry.

## Secrets

These are frustrating. You should be able to call them by a custom name, and specify
source to point it at the correct secret, but I couldn't get this to work. What is
in the `images/docker-compose.yml` file is what I could get to work.

https://github.com/moby/moby/issues/32822
https://github.com/docker/compose/issues/4510
