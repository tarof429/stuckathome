# Using Dockerfile

To create a custom docker image we can utilize a Dockerfile. The `files/redis-example` shows a very simple example where we create a custom docker image. The base image in this case is alpine. 

To build the image, type:

```sh
sudo docker build . -t redis-example
```

To run the container, type:

```sh
docker run redis-example
1:C 04 Nov 2024 21:35:40.086 # WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
1:C 04 Nov 2024 21:35:40.086 * oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 04 Nov 2024 21:35:40.086 * Redis version=7.2.5, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 04 Nov 2024 21:35:40.086 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
1:M 04 Nov 2024 21:35:40.087 * monotonic clock: POSIX clock_gettime
1:M 04 Nov 2024 21:35:40.087 * Running mode=standalone, port=6379.
1:M 04 Nov 2024 21:35:40.087 * Server initialized
1:M 04 Nov 2024 21:35:40.087 * Ready to accept connections tcp
```

Notice that in this output, redis listens to port 6379.

Each `RUN` command in the Dockerfile will be added as a layer in the docker image. Subsequent builds will be faster since they leverage these layers from the cache.

If the order of the RUN statements change, Docker cannot leverage the cache.

## Using Node in a docker image

The simpleweb example runs a web application built with nodejs. To build it, run:

```sh
docker build -t simpleweb .
```

Then to run it:

```sh
docker run -d -p 8080:8080 simpleweb:latest
```

Note that in this Dockerfile we have two COPY statements. This can vastly improve the image build speed so IF we know that the application has a part that does not change very often if it is good to take advantage of multiple COPY statements.

## References

https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide

https://github.com/tarof429/spring-boot-demo