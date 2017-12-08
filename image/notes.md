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

To sign an image, have the `DOCKER_CONTENT_TRUST` set, issue a `docker push`. This will have Docker generaate
a root certificate for you, and store it in ~/.docker/trust registry.

## Secrets

These are frustrating. You should be able to call them by a custom name, and specify
source to point it at the correct secret, but I couldn't get this to work. What is
in the `images/docker-compose.yml` file is what I could get to work.

https://github.com/moby/moby/issues/32822
https://github.com/docker/compose/issues/4510

# Docker EE Installation

## CentOS 7

### Yum

To install Docker EE on CentOS, essentially you take you get your repo URL from your account, and set that as a
repo in your yum config. They recommend this (which isn't a bad idea).

```
export DOCKERURL='<DOCKER-EE-URL>'
sudo -E sh -c 'echo "$DOCKERURL/centos"ff > /etc/yum/vars/dockerurl'
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo -E yum-config-manager \
    --add-repo \
    "$DOCKERURL/centos/docker-ee.repo"
sudo yum install install -y docker-ee
```

The storage driver has to be `devicemapper` in EE, apparently and "on production systems, you must use `direct-lvm` mode, which requires
one or more dedicated block devices", but I'm not sure what `direct-lvm` is yet.

By default, the device driver is configured in `/etc/docker/daemon.json`, and with `devicemapper`, it would look like this.

```
{
  "storage-driver": "devicemapper"
}
```

The `DOCKER-EE-URL` from earlier is specific to the version you are on (like 17.06 or 17.09), so if you want to move
major version, you need to grab a new URL, and add that repository. Then you run through the normal install process.

### RPM

If you want to use the RPM, basically you download it, and install it with yum.

`sudo yum install /path/to/package.rpm`

You'll still need to configure device mapper, though.

## Most Other Linux Distros.

They are all some variant of add to package manager, install, and configure storage driver. The exceptions I see are these.

* RHEL7 SELinux and Docker don't support IBM Z series (I didn't know Red Hat did)
* SLES requires BTRFS and manual iptable updates
  * If you see errors like this, adjust the start-up script order so that the firewall is started before Docker, and Docker stops before the firewall stops. See the SLES documentation on init script order.
  * `{ "storage-driver": "btrfs" }`
* Ubuntu uses the `aufs` storage driver, but it doesn't appear you have to configure this

## Windows

Basically you install a PS Module, and install it the hard way. Just go through this again before the exam.

https://docs.docker.com/engine/installation/windows/docker-ee/#optional-make-sure-you-have-all-required-updates

# Troubleshooting the Docker Daemon

You can run `dockerd` right in the console to see the output.

You can set `debug: true` in the daemon config to get more detailed output. This can also be done with the `-D` flag.

If you send a `SIGUSR` to the daemon, you'll get a full stack trace. `sudo kill -SIGUSR1 $(pidof dockerd)`. Windows will require
you to download the docker-signal tool to achieve the same.

# UCP Usage

This will need some hands on time. There are a lot of things going on, but it looks pretty straight forward.

## Creating Users

It's basically click add, enter a username and password, and click create.

## Manage User and Teams

Basically, create a group of resources, and create teams, then say who can do what on those resources.

##
