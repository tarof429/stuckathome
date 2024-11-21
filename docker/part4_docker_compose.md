# Docker Compose

## Introduction

Using docker compose, we can start and manage (orchestrate) multiple docker containers. 

## Implementation

The `visits-app` application is an example of using docker-compose. One image, redis:alpine, is a dependency of our own image which we define using Dockerfile. The docker-compose file specifies eech container as a service. To get the NodeJS application to talk to the Redis container we specify the service name and port inside index.js. 

To build the example:

```sh
docker-compose build
```

To run the example:

```sh
docker-compose up
```

You can perform both steps like this:

```sh
docker-compose up --build
```

Using curl:

```sh
curl http://localhost:4001
Number of visits is 0
...
```

To start the application in the background, we can use the -d option.

```sh
docker compose up -d
```

To stop the application we would run:

```sh
docker compose down
```