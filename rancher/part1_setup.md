# Installing Rancher on KVM

The following steps creates a 3 node Kubernetes cluster using Rancher.

## Create the kubemaster
    
  1. Provision the kubemaster VM.

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n kubemaster -i 192.168.0.30 -u ubuntu -p pass123 -s 40G
    ```

  2. Login to the VM, update packages, and reboot

    ```
    sudo apt update
    sudo apt upgrade
    reboot
    ```

## Create the first node


1. Provision the first Kubernetes worker node

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n kubenode01 -i 192.168.0.31 -u ubuntu -p pass123 -s 40G
    ```

2. Update and reboot

## Create the second node

1. Provision the second Kubernetes worker node

  ```
  sh ./create_seeded_ubuntu_vm.sh  -n kubenode02 -i 192.168.0.32 -u ubuntu -p pass123 -s 40G
  ```

  2. Update and reboot


## Summary

These steps created three nodes:

kubemaster 192.168.0.30
kubenode01 192.168.0.31
kubenode02 192.168.0.32

## Setup the nodes  

Run the ansible role to install docker, helm, kubectl on all nodes

```
ansible-playbook setup.yml 
```
## Install Rancher with Helm

Follow the instructions at https://rancher.com/docs/rancher/v2.6/en/quick-start-guide/deployment/quickstart-manual-setup/ to install Rancher. 

## References

https://rancher.com/docs/rancher/v2.5/en/quick-start-guide/deployment/quickstart-manual-setup/