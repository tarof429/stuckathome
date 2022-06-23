# Installing k3s on KVM

The following steps creates a 3 node Kubernetes cluster using k3s.

## Create the kubemaster
    
  1. Provision the kubemaster VM.

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n k3smaster -i 192.168.0.40 -u ubuntu -p pass123 -s 40G
    ```

  2. Login to the VM, update packages, and reboot

    ```
    sudo apt update; sudo apt upgrade
    reboot
    ```

## Create the first node


1. Provision the first Kubernetes worker node

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n k3snode01 -i 192.168.0.41 -u ubuntu -p pass123 -s 40G
    ```

2. Update and reboot

## Create the second node

1. Provision the second Kubernetes worker node

  ```
  sh ./create_seeded_ubuntu_vm.sh  -n k3snode02 -i 192.168.0.42 -u ubuntu -p pass123 -s 40G
  ```

  2. Update and reboot


## Summary

These steps created three nodes:

k3smaster 192.168.0.40
k3snode01 192.168.0.41
k3snode02 192.168.0.42

## Install k3s

## References

https://k3s.io/
