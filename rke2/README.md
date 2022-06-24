# RKE

The following steps creates a 3 node Kubernetes cluster using rke2.

## Create the kubemaster
    
  1. Provision the rke2master VM.

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n rke2master -i 192.168.0.50 -u ubuntu -p pass123 -s 40G
    ```

## Create the first node


1. Provision the first Kubernetes worker node

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n rke2worker01 -i 192.168.0.41 -u ubuntu -p pass123 -s 40G
    ```


## Create the second node

1. Provision the second Kubernetes worker node

  ```
  sh ./create_seeded_ubuntu_vm.sh  -n rke2worker02 -i 192.168.0.42 -u ubuntu -p pass123 -s 40G
  ```


## Summary

These steps created three nodes:

rke2master 192.168.0.40
rke2worker01 192.168.0.41
rke2worker02 192.168.0.42

## Setup the nodes  

Run the ansible role to install docker, helm, kubectl on all nodes

```
ansible-playbook setup.yml 
```