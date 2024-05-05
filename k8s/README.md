# README

## The Problem Statement

In the past, applications and their dependencies were deployed directly to servers. Whenever there was a new version of the application or its dependencies, the operations team was responsible for ensuring that changes in one application wouldn't break another application. Containers solved this dependency hell by isolation applications from each other in their own envioronments. If a container misbehaved or needed to be updated, operators could make a change without affecting any other containers. Developers could just concentrate on implementing microservices instead of a monolithic application where each of the components were tightly coupled with each other. Furthermore, containers were guaranteed to run correctly regardless of the host environment.

This however led to another problem: how to orchestrate the lifecycle of these containers. The solution that Google came up with is called Kubernetes and is the most popular solution to container orchestration soluton. Kubernetes is difficult to setup but provides a variety of ways to customize. In Kubernetes, a worker node is reponsible for running containers while the master node is responsible for scheduling containers. Multiple nodes make up a cluster, and true to its namesake, if a node becomes unavailable, workloads failover to other nodes. 

When users interact with master nodes, they actually communicate with the API server. The command-line tool is called `kubectl`. Workload requests then get procesed by the scheduler, which stores information about the nodes and containers in a key store database like etcd. Each worker node runs a kubelet which talk to the API server or kube-apiserver and ensures the containers are running. 

## This Project

The project can be used to create VMs for a Kubernetes cluster. It requires a Linux host with KVM capabilities.

## Create the VMs

Below is a script to create 3 Ubuntu 22 VMs.

```sh
cd files
sh ./create_vms.sh
```

This script has some logic to shutdown the VMs once before bringing them up again. This is a workaround for an odd behavior where the first reboot command in Ubuntu will actually shutdown the VM. 

## Summary

These steps created three nodes:

kubemaster 192.168.1.30
worker01 192.168.1.31
worker02 192.168.1.32

## Next Steps

To create the cluster, follow the steps in the rke2 directory. Then come back here for more basic tutorials.

## Debugging Kubernetes

In the past, Kubernetes supported natively and then through the docker shim. The current release of Kubernetes no longer supports docker shim. Kubernetes provides a CLI tool called `crictl` for debugging. Outside of Kubernetes you can use `containerd` or `nerctl`.

## References

- https://www.udemy.com/course/learn-kubernetes/

- https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests

- https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl

