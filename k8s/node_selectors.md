# Node selectors

NodeSelectors can be used to help the scheduler schedule pods on particular nodes. 

To define a NodeSelector for a pod, run:

```sh
kubectl explain pod --recursive | grep -i -B5  nodeSelector
  spec	<PodSpec>
  ...
    nodeName	<string>
    nodeSelector	<map[string]string>
```

This tells you that NodeSelector is a map of key/value pairs and is deined below the spec section. The key needs to be mapped to a label on a node. To lable a node, run:

```sh
kubectl label nodes <node name> <key>=<value>
```

For example:

```sh
kubectl label nodes worker01 size=large
node/worker01 labeled
```

To confirm  the label:

```sh
kubectl describe node worker01 | grep  size
                    size=large
```

Then deploy a pod with the nodeSelector set to this label:

```sh
$ cat pod.yaml 
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
  nodeSelector:
    size: large
```



