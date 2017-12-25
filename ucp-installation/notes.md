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

## UCP Notes

In a Docker EE Swarm, manager should not run workloads. They should run UCP controllers, and nothing else.
