# Deployments

Below is an example of a Deployment. It is very similar to the defiition of a ReplicaSet. In fact, Deployments create ReplicaSets.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

You can put this in a file and run `kubectl apply -f <file> to create the deployment.

Just like pods, you can create the deployment on the fly.

```
kubectl create deployment --image=nginx nginx
```

You can also generate the yaml and dump it to a file.

```
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml
```

Unlike a ReplicaSet, a Deployment performs rolling updates of pods. This makes Deployments suitable for production environments.

Below are some additional features of Deployments:

- The image can be updated by running a command such as `kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.16.1`

- The rollout status can be seen by running a command such as `kubectl rollout status deployment/nginx-deployment`

- The rollout history can be seen by running a command such as `kubectl rollout history deployment/nginx-deployment`

- You can quickly roll back to a previous verison by running a command such as `kubectl rollout undo deployment/nginx-deployment`

