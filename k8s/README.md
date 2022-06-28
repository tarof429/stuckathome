
# README

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

  