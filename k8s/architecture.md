# Kubernetes Architecture

![alt text](https://kubernetes.io/images/docs/kubernetes-cluster-architecture.svg)

## Introduction

Now we're going to talk a little about Kubernetes Architeture. 

### Nodes

A node is either a virtual or physical machine that runs workloads. These workloads are in the form of containers.

If the node fails, then obviously the containers will also fail. This is the reason why in Kubernetes several nodes are grouped together to form a cluster. 

#### Master Node

There is a special node called a master node which is responsible for scheduling workloads, and handling failures. 

Within the master node is what's called the control plane and consists of the following: API server, etcd, kubelet, container runtime, the controller, and the scheduler.

The API server or kube-apiserver acts as the frontend to Kubernetes. CLI and GUI tools all go through the API server to interact with the cluster. 

The etcd keystore is a key-value database, often distributed accross multiple masters, storing information about the cluster. 

The scheduler is responsible for scheduling workloads across multiple nodes. The scheduler schedules workloads based on the capacity and availability of the node in addition to other conditions such as constraints. 

The controller is the brain behind container orchestration within the cluster. 

The container runtime (CRI) is responsible for running containers. 

#### Worker Node

The workr node is a node that actually performs the workload. The kubelet is the agent that runs on each worker node. The kubelet is responsible for ensuring containers are running on the node as expected, and as directed by the kube-apiserver. 