# ReplicaSets

The Replication Controller is responsible for creating replicas of pods for high availabiltiy.

A ReplicaSet is an object that strives to maintain a fixed number of replicas of a pod. It is a low-level object that replaces the Replication Controller. 

In most cases, it is recommended to use Deployments instead.

An example is shown below.

```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3
```

To increase the number of replicas, you can:

- Change the number of replicas in the replicaset definition file and run `kubectl replace -f <file>`

- Run `kubectl scale --replicas=<number> -f <file>`

- Run `kubectl scale --replicas=<number> <replicaset name>`


## References

https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/