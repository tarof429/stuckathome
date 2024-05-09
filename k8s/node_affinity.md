# Node Affinity

## Introduction

NodeSelectors have some limitations. For example, with a NodeSelector, you can place pods on nodes that match a label exactly. However, you cannot say "place a pod on a node that is either label A or label B, or does not match label A or label B. F.

NodeAffinity addresses some of the shortcomings of NodeSelector. 

See https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/ for an example.

## Usage

Below is an example of matching a lable of size=Large

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: size
            operator: In
            values:
            - Large 
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
```

If you want to place pods on nodes that have a label of Large or Medium, simply add another item in the list.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: size
            operator: In
            values:
            - Large
            - Medium    
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
```

For a deployment, nodeAffinity goes into the template section:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    color: blue
  name: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      color: blue
  template:
    metadata:
      labels:
        color: blue
    spec:
      containers:
      - image: nginx
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: color
                operator: In
                values:
                - blue

```

The example below will be scheduled on a node that simply has the label node-role.kubernetes.io/control-plane. 

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    color: blue
  name: blue
spec:
  replicas: 2
  selector:
    matchLabels:
      color: blue
  template:
    metadata:
      labels:
        color: blue
    spec:
      containers:
      - image: nginx
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/control-plane
                operator: Exists
```



## References

https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
