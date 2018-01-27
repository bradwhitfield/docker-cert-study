# Mounts

https://docs.docker.com/engine/admin/volumes/bind-mounts/

I have not heard of these until now. Mounts are more verbose and flexible, essentially.

The one difference besides extensibility for the future, or verbosity is that volumes will
create a directory on the host if it doesn't exist already.

Volumes aren't support in Swarm. You have to use the `--mount` flag instead.

# The way I remember which are block level, and which are file level storage drivers

^ That's an overaly long title.

`devicemapper` can be used with `direct-lvm`, which takes a raw **device**, and provisions
the bits for the filesystem as needed (kind of). BTRS and ZFS are fancy file system that do
block level manipulation for task like detecting duplicate files at seperate paths, and pointing
both to the same bits on disk (e.g. if /home/user/file1 and /home/user/file2 are identical
files, these filesystems will point both paths to the same bits). Because these all do
block level file management, these are block level storage systems. Block level usually
consume more memory, but can be more performant when dealing with large amounts of data
(although if you have large amounts of data, consider using volumes).

File level drivers are the rest of them (AUFS, overlay, and overlay2). I don't know how I
remember AUFS is file level, but I can explain the others.

In overlay and overlay2, as the tar files get extracted, the final file system is kind
of what it would look like to look at them top down, or overlay.

Example:
I'm not typing out file paths so pretend these are file name and paths.
```
Layer3: f o   b   r
Layer2:   a o    
Layer1: f   i   a d
```

So if you look at it from the top, looking down, you would see `f o o b a r`
