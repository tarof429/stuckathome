# Using Docker

## Running images

To run a docker image, use the `run` command.

```
docker run hello-world
```

If the image is not availabe locally in your image cache, the docker client will pull the image from docker hub.

Now if you run the docker run command again, the docker client will run the hello-world image from the local image cache.

Note that the `run` command can also take an argument to override the default command. For example:

```
docker run busybox /bin/ls /      
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
405fecb6a2fa: Pull complete 
Digest: sha256:fcd85228d7a25feb59f101ac3a955d27c80df4ad824d65f5757a954831450185
Status: Downloaded newer image for busybox:latest
bin
dev
etc
home
proc
root
sys
tmp
usr
var
```

## Pulling images

To just pull images, use the `pull` command.

```
docker pull hello-world
```

## Listing images

To see docker images in your local cache, use the `images` command.

```
$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
hello-world   latest    feb5d9fea6a5   14 months ago   13.3kB
```

## About Containers and Images

An Image is like an archive that contains all the dependencies needed to run a program.

A container is an instance of an image. You can have multiple containers for a single image running on your computer.

Containers and images are made possible through namespacing and control groups (cgroups). These are features of the Linux kernel. 

## Listing containers

Let's first run a container indefinitely:

```
docker run -t busybox /bin/sh
/ #
```

Open a container and see running containers.

```
$ docker ps
CONTAINER ID   IMAGE     COMMAND     CREATED          STATUS          PORTS     NAMES
db5b95f431e1   busybox   "/
```

## Starting stopped containers

If you run docker ps -a, you may see a long list of containers that have stopped. To run these containers again, use the `run` command. You should also use the -`a` option to see the output. The following session shows an example:

```
$ docker run busybox echo hello
hello
$ docker ps -a |grep busybox
ffc6429b0b40   busybox        "echo hello"             8 seconds ago   Exited (0) 7 seconds ago              loving_beaver

docker start -a ffc6429b0b40
hello
```

## Removing stopped containers

If you want to remove all containers that have exited, run: 

```
docker rm  $(docker ps --filter status=exited -q)
```

To simply remove all stopped containers, 

```
docker container prune
```

## Creating containers

Here is a less useful command: `create`.

The `create` command creates a container without running it.

```
$ docker create busybox ping google.com
b2ac35c8ff083914f3b5db45c49536f33444979a548f181d2857a4ad0b01a642

$ docker start -a b2ac35c8ff083914f3b5db45c49536f33444979a548f181d2857a4ad0b01a642
PING google.com (142.251.46.174): 56 data bytes
64 bytes from 142.251.46.174: seq=0 ttl=114 time=13.593 ms
64 bytes from 142.251.46.174: seq=1 ttl=114 time=13.582 ms
64 bytes from 142.251.46.174: seq=2 ttl=114 time=13.286 ms
```

The `-a` option used here is used to attach the terminal to the container output.

## Additional Topics

See the tutorial at https://docs.docker.com/get-started/02_our_app/. This covers:

- Using Dockerfile
- Volumes
- Bind mounts
- Networks
- Using Docker Compose

## References

https://docs.docker.com/reference/