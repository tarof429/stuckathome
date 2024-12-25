# Docker in the Real World

## Introducing the frontend application

The `frontend` application is a react application that was generated by npm. The steps to generate the application are:

1. npx create-react-app frontend
2. npm start

Some things to note about npm:

- `npm run start` will start a development environment
- `npm run test` runs tests associated with the application
- `npm run build` will build a production environment

To build the development environment, run:

```sh
docker build -f Dockerfile.dev -t frontend-dev .
```

To run the development environment, run:

```sh
docker run --rm -p 3000:3000 -v $(pwd)/src:/app/src frontend-dev
```

Here we take advantage of volume mounts so that we can edit files under the src directory and they will be updating inside the container.

As a good practice, delete the node_modules directory so that Docker wont' copy it when ceating the container

If docker cannot find the `node_modules` directory in the local filesystem, then add an argument to ignore it: `-v $(pwd)/src/node_modules`.

To build the tests, run:

```sh
docker build -f Dockerfile.test  -t frontend-test .
```

To run the tests, run:

```sh
docker run --rm frontend-test
```

The production environment makes use of multiple docker images so that the resulting image is as small as possible. To build it, run:

```sh
docker build -t frontend .
```

A better approach is to use the docker-compose.yml file.

```sh
docker compose build
```

To run the production environment:

```sh
docker run -p 8080:80 --rm frontend
```

or better yet:

```sh
docker compose up
```