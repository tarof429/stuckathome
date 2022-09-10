# Creating Ansible modules

This example shows how to create a Ansible custom task to query RPMs installed in a KVM guest. It is based on https://gist.github.com/halberom/f4515e6b9d977f64294d but uses playbooks.

## Create the CentOS VM using cloud-init

To run this example, first create a CentOS VM using cloud-init.

1. Download https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2 and move it to /var/lib/libvirt/images

2. Now run `kvm/create_seeded_centos_vm.sh `.

  ```
  cd files/kvm
  sh ./create_seeded_centos_vm.sh  -n test-centos -i 192.168.1.35 -u centos -p pass123 -s 40G
  ```

## Run the Ansible role

```
cd files/ansible/gather_installed
ansible-playbook gather_installed.yml
```

## Tips and Tricks

- If you are unable to start the VM at a later time because you get the error: 
  
  ```
  error: Cannot access storage file '/tmp/test-centos/cloud-init.iso': No such file or directory
  ```

  Then eject the CDROM.

  ```
  sudo virsh change-media test-centos sda --eject
  ```
