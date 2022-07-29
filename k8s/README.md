# README

## The Problem Statement

In the past, applications and their dependencies were deployed directly to servers. Whenever there was a new version of the application or its dependencies, the operations team was responsible for ensuring that changes in one application wouldn't break another application. Containers solved this dependency hell by isolation applications from each other in their own envioronments. If a container misbehaved or needed to be updated, operators could make a change without affecting any other containers. Developers could just concentrate on implementing microservices instead of a monolithic application where each of the components were tightly coupled with each other. Furthermore, containers were guaranteed to run correctly regardless of the host environment.

This however led to another problem: how to orchestrate the lifecycle of these containers. The solution that Google came up with is called Kubernetes and is the most popular solution to container orchestration. Kubernetes is difficult to setup but provides a variety of ways to customize. In Kubernetes, a worker node is reponsible for running containers while the master node is responsible for scheduling containers. Multiple nodes make up a cluster, and true to its namesake, if a node becomes unavailable, workloads failover to other nodes. 

When users interact with master nodes, they actually communicate with the API server. The command-line tool is called kubectl. Workload requests then get procesed by the scheduler, which stores information about the nodes and containers in a key store database like etcd. Each worker node runs a kubelet which talk to the API server or kube-apiserver and ensures the containers are running. 

## This Project

The project can be used to create VMs for a Kubernetes cluster. It requires a Linux host with KVM capabilities.

## Create the kubemaster
    
  1. Provision the kubemaster VM.

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n kubemaster -i 192.168.0.30 -u ubuntu -p pass123 -s 40G
    ```

## Create the first node


1. Provision the first Kubernetes worker node

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n worker01 -i 192.168.0.31 -u ubuntu -p pass123 -s 40G
    ```

## Create the second node

1. Provision the second Kubernetes worker node

  ```
  sh ./create_seeded_ubuntu_vm.sh  -n worker02 -i 192.168.0.32 -u ubuntu -p pass123 -s 40G
  ```

## Summary

These steps created three nodes:

kubemaster 192.168.0.30
worker01 192.168.0.31
worker02 192.168.0.32

## Tips and Tricks

- If you are unable to start the VM at a later time because you get the error: 
  
  ```
  error: Cannot access storage file '/tmp/kubemaster/cloud-init.iso': No such file or directory
  ```

  Eject the ISO.

  ```
  sudo virsh change-media kubemaster sda --eject
  ```

## Next Steps

Follow the steps in the rke2 directory.

## References

https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/

https://www.golinuxcloud.com/kubernetes-sidecar-container/