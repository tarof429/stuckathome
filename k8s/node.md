# Nodes

A node is either a virtual or physical machine taht runs workloads. 

To view a Node's status, run:

```
kubectl describe node <node>
```

Since each node is responsible for creating pods, it must have a container runtime such as containerd. 

There are two types of nodes: master nodes and worker nodes. 

## Master Node

There must be at least one master node per cluster. It is comprised of the API server, etcd, controller manager, and scheduler. 

### kube-apiserver

The Kubernetes API server serves as a frontend for the cluster. It is the only component that directly interacts with etcd. 

### etcd

etcd is a key-value store that contains information about the cluster. 

### kube-controller-manager

The controller manager ensures the desired state of the cluster. 

### kube-scheduler

The scheduler assigns pods to nodes. 

## Worker Node

The worker noe runs scheduled pods. It is comprised of the kubelet, kube-proxy, and container runtime.

### Kubelet

The kubelet communicates with the API server. It is responsible for starting and terminating pods and ensuring that pods are running and healthy. 

### Kube-proxy

The kube-proxy is responsible for managing the network within the worker node.

### Conainer runtime

The container runtime is responsible for running containers on the ndoe.

# References

https://www.weave.works/blog/kubernetes-node-everything-you-need-to-know