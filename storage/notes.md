# Mounts

https://docs.docker.com/engine/admin/volumes/bind-mounts/

I have not heard of these until now. Mounts are more verbose and flexible, essentially.

The one difference besides extensibility for the future, or verbosity is that volumes will
create a directory on the host if it doesn't exist already.

Volumes aren't support in Swarm. You have to use the `--mount` flag instead.
