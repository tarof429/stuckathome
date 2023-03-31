# Real Life Examples

## Example 1

https://www.freecodecamp.org/news/how-to-get-started-with-docker-using-nodejs/ is a simple example of using Docker to run a Nodejs app. The container was run with the command:

```
docker run -d -p 8000:8000 tarof429/node_with_docker:v1
```

Likewise, the image was pushed to my own Docker repository.

```
$ docker push tarof429/node_with_docker:v1
The push refers to repository [docker.io/tarof429/node_with_docker]
d1a870bbb327: Pushed 
62ef874e10c2: Pushed 
4cbd73f4a007: Pushed 
a229f6e7a615: Mounted from library/node 
d25cfc53cd3f: Mounted from library/node 
bf55b14248a7: Mounted from library/node 
7efd70d0bc36: Mounted from library/node 
d4514f8b2aac: Mounted from library/node 
5ab567b9150b: Mounted from library/node 
a90e3914fb92: Mounted from library/node 
053a1f71007e: Mounted from library/node 
ec09eb83ea03: Mounted from library/node 
v1: digest: sha256:975561a717421e9b4ad683a8f6dd0826e4e9cc14e18f611ea152ed25efbbb861 size: 2842
```

## Example 2

https://www.freecodecamp.org/news/build-and-push-docker-images-to-aws-ecr/ is an example of pushing a docker image to ECR.

After pushing the image to ECR, it is a good idea to delete it to avoid the cost of storage.

## References

https://www.freecodecamp.org/news/how-to-get-started-with-docker-using-nodejs/