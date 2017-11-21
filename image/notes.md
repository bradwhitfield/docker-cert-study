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
