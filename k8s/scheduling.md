# Scheduling

## Taints and tolerations

Taints and tolerations work together to help the scheduler schedule pods on nodes. The taint is applied to a node. If a pod is tolerant of the taint, it can be scheduled on the node. Coverseley, if the pod is intolerant of the taint, it cannot be scheduled on the ndoe. 

### Usage

Below is an example on how to apply a taint to a node.

```sh
kubectl taint nodes <node-name> gpu=true:NoSchedule
```

The taint-effect field can have one of three values:

- NoSchedule
- PreferNoSchedule
- NoExecute

Tolerations are defined in the pod defintion file.

```yml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  containers:
  - name: my-app
    image: my-app-image
  tolerations:
  - key: "gpu"
    operator: "Exists"
    effect: "NoSchedule"
```

Another example:

```yml
apiVersion: v1
kind: Pod
metadata:
  name: bee
  labels:
    name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  tolerations:
  - key: "spray"
    operator: "Equal"
    value: "mortein"
    effect: "NoSchedule"
```

Below is an example of removing from node 'controlplane' all the taints with key 'node-role.kubernetes.io/control-plane'

```
$ kubectl taint nodes controlplane node-role.kubernetes.io/control-plane-
```

### Exam notes

If you search for 'taints' on  https://kubernetes.io/, scroll down to the link 'kubectl taint' for good examples of removing a taint. 

Without looking things up line you can run:

```sh
$ kubectl explain pod --recursive| grep -i -B5 toleration
    serviceAccountName	<string>
    setHostnameAsFQDN	<boolean>
    shareProcessNamespace	<boolean>
    subdomain	<string>
    terminationGracePeriodSeconds	<integer>
    tolerations	<[]Toleration>
      effect	<string>
      key	<string>
      operator	<string>
      tolerationSeconds	<integer>
```

## Node Affinity

NodeSelectors have some limitations. For example, with a NodeSelector, you can place pods on nodes that match a label exactly. However, you cannot say "place a pod on a node that is either label A or label B, or does not match label A or label B. F.

NodeAffinity addresses some of the shortcomings of NodeSelector. 

See https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/ for an example.

### Usage

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

## Node selectors

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

## DaemonSets

A daemonset ensures that one copy of a pod is deployed on every node in yoru cluster. 

## Static pods

Static pods are pods that are run by kubelets without direction from the API server. 

Kubelets deploy pods defined in manifest files and stored in specific locations in the filesystem. 

The path is passed into the kubelet as a runtime parameter called pod-manifest-path. It can also be specified in the kubeconfig file by the staticPodPath option. 

Static pods cannot be modified by kubectl.

One thing to note on the exam is that static pods can be running on any node. If you try to delete the static pod and it comes back up, try to find out what node the pod is running on and then checking the kubelet process to find the location of the static pod manifests on that machine.

## Multiple Schedulers

Although Kubernets comes with a default scheduler, it is possible to implement custom schedulers. 

## Troubleshooting Schedulng

Look at the event log to see how pods are being scheduled.

```sh
kubectl get events -o wide
```

You can also look at logs from the sceduler (as if it is a pod):

```sh
kubectl logs kube-scheduler -n kube-system
```

## Troubleshooting resource usage

Below are two commands that you can use to see how much resources a pod or node is currently using:

```sh
kubectl top pod
kubectl top node
```

## References

https://medium.com/@prateek.malhotra004/demystifying-taint-and-toleration-in-kubernetes-controlling-the-pod-placement-with-precision-d4549c411c67

https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/

https://kubernetes.io/docs/reference/kubectl/generated/kubectl_taint/

https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/

https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/

https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/
