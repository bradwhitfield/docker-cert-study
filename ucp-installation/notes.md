# Docker EE Installation

## CentOS 7

### Yum

To install Docker EE on CentOS, essentially you take you get your repo URL from your account, and set that as a
repo in your yum config. They recommend this (which isn't a bad idea).

```
export DOCKERURL='<DOCKER-EE-URL>'
sudo -E sh -c 'echo "$DOCKERURL/centos" > /etc/yum/vars/dockerurl'
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo -E yum-config-manager \
    --add-repo \
    "$DOCKERURL/centos/docker-ee.repo"
sudo yum install install -y docker-ee
```

The storage driver has to be `devicemapper` in EE, apparently and "on production systems, you must use `direct-lvm` mode, which requires
one or more dedicated block devices". This means that Docker will provision drive space as it needs it on the block device, basically. Then you can extend the block device later.

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

## DTR Install Notes

When you install DTR, it will bind a node to the System namespace of the swarm, and will prevent you from changing it.

### DTR APIs

* `/health` return status and error message, if applicable
* `/_ping` is the same, but is unauthenticated
* `/api/v0/meta/cluster_stats` returns all the details about the DTR replicas health status
* `/nginx_status` does what you think it does

# UCP Install.

It's worth reviewing all of the flags you can pass to a UCP install.

```
C:\Users\bradw> docker run docker/ucp install --help
Docker Universal Control Plane Tool

   install - Install UCP on this node

USAGE:
   docker run --rm -it \
        --name ucp \
        -v /var/run/docker.sock:/var/run/docker.sock \
        docker/ucp \
        install [command options]

DESCRIPTION:

This command initializes a new swarm, turns this node into a manager, and installs
Docker Universal Control Plane (UCP).

When installing UCP you can customize:

  * The certificates used by the UCP web server. Create a volume
    named 'ucp-controller-server-certs' and copy the ca.pem, cert.pem, and key.pem
    files to the root directory. Then run the install command with the
    '--external-server-cert' flag.

  * The license used by UCP, by bind-mounting the file at
    '/config/docker_subscription.lic' in the tool.  E.g. -v /path/to/my/config/docker_subscription.lic:/config/docker_subscription.lic
    or by specifying with '--license "$(cat license.lic)"

If you're joining more nodes to this swarm, open the following ports in your
firewall:

  * 443 or the '--controller-port'
  * 2376 or the '--swarm-port'
  * 2377 or the swarm-mode listen port
  * 12376, 12379, 12380, 12381, 12382, 12383, 12384, 12385, 12386, 12387
  * 4789(udp) and 7946(tcp/udp) for overlay networking

If you have SELinux policies enabled for your Docker install, you will need to
use 'docker run --rm -it --security-opt label=disable ...' when running this
command.


OPTIONS:
   --debug, -D                  Enable debug mode
   --jsonlog                    Produce json formatted output for easier parsing
   --interactive, -i            Run in interactive mode and prompt for configuration values
   --admin-username value       The UCP administrator username [$UCP_ADMIN_USER]
   --admin-password value       The UCP administrator password [$UCP_ADMIN_PASSWORD]
   --san value                  Add subject alternative names to certificates (e.g. --san www1.acme.com --san www2.acme.com) [$UCP_HOSTNAMES]
   --host-address value         The network address to advertise to other nodes. Format: IP address or network interface name [$UCP_HOST_ADDRESS]
   --data-path-addr value       Address or interface to use for data path traffic. Format: IP address or network interface name [$UCP_DATA_PATH_ADDR]
   --swarm-port value           Port for the Docker Swarm manager. Used for backwards compatibility (default: 2376)
   --controller-port value      Port for the web UI and API (default: 443)
   --swarm-grpc-port value      Port for communication between nodes (default: 2377)
   --dns value                  Set custom DNS servers for the UCP containers [$DNS]
   --dns-opt value              Set DNS options for the UCP containers [$DNS_OPT]
   --dns-search value           Set custom DNS search domains for the UCP containers [$DNS_SEARCH]
   --unlock-key value           The unlock key for this swarm-mode cluster, if one exists. [$UNLOCK_KEY]
   --existing-config            Use an existing UCP config during this installation. The install will fail if a config is not found
   --pull value                 Pull UCP images: 'always', when 'missing', or 'never' (default: "missing")
   --registry-username value    Username to use when pulling images [$REGISTRY_USERNAME]
   --registry-password value    Password to use when pulling images [$REGISTRY_PASSWORD]
   --kv-timeout value           Timeout in milliseconds for the key-value store (default: 5000) [$KV_TIMEOUT]
   --kv-snapshot-count value    Number of changes between key-value store snapshots (default: 20000) [$KV_SNAPSHOT_COUNT]
   --swarm-experimental         Enable Docker Swarm experimental features. Used for backwards compatibility
   --disable-tracking           Disable anonymous tracking and analytics
   --disable-usage              Disable anonymous usage reporting
   --external-server-cert       Customize the certificates used by the UCP web server
   --preserve-certs             Don't generate certificates if they already exist
   --binpack                    Set the Docker Swarm scheduler to binpack mode. Used for backwards compatibility
   --random                     Set the Docker Swarm scheduler to random mode. Used for backwards compatibility
   --external-service-lb value  Set the IP address of the load balancer that published services are expected to be reachable on
   --enable-profiling           Enable performance profiling
   --license value              Add a license: e.g. --license "$(cat license.lic)" [$UCP_LICENSE]
```
