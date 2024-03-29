# Installing Rancher on KVM

The following steps creates a 3 node Kubernetes cluster using Rancher.

## Download the latest cloud images

1. Download the latest LTS cloud init image for Ubuntu.

    ```
    cd ~/Downloads
    wget https://cloud-images.ubuntu.com/releases/22.10/release/ubuntu-22.10-server-cloudimg-amd64.img
    ```

3. Move it to /var/lib/libvirt/boot

    ```
    sudo mv ~/Downloads/ubuntu-22.10-server-cloudimg-amd64.img /var/lib/libvirt/boot/
    ```

## Create the kubemaster
    
Scripts to create VMs using KVM are in the KVM directory.

  1. CD to the KVM directory

    ```
    cd files/kvm
    ```

  1. Provision the kubemaster VM. You may want to use different credentials for your VM.

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n kubemaster -i 192.168.1.30 -u ubuntu -p pass123 -s 40G
    ```

    The VM should be up and running in a few minutes. Keep it running and let it update packages.

    Note: if the VM is unable to ping 8.8.8.8, then the network settings for the VM may be incorrect. Review the scripts and configuration and try again.

  2. Login to the VM using the credentials you provided earlier and reboot to load the latest kernel.

    ```
    sudo reboot
    ```

## Create the first node


1. Provision the first Kubernetes worker node

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n kubenode01 -i 192.168.1.31 -u ubuntu -p pass123 -s 40G
    ```

2. Login and reboot

## Create the second node

1. Provision the second Kubernetes worker node

  ```
  sh ./create_seeded_ubuntu_vm.sh  -n kubenode02 -i 192.168.1.32 -u ubuntu -p pass123 -s 40G
  ```

  2. Login and reboot


## Summary

These steps created three nodes:

kubemaster 192.168.1.30
kubenode01 192.168.2.31
kubenode02 192.168.3.32

## Setup the nodes  

Run the ansible role to install docker, helm, kubectl on all nodes

```
ansible-playbook setup.yml 
```

## Deploying Rancher Server Manually

There are several guides to deploy Rancher as outlined at https://ranchermanager.docs.rancher.com/pages-for-subheaders/deploy-rancher-manager. We will deploy rancher locally so we will follow the manual instructions at https://ranchermanager.docs.rancher.com/getting-started/quick-start-guides/deploy-rancher-manager/helm-cli.

These instructions need to be run on kubemaster. 

## Tips and Tricks

- Install helm by following: https://helm.sh/docs/intro/install/



## References

https://rancher.com/docs/rancher/v2.6/en/installation/install-rancher-on-k8s/