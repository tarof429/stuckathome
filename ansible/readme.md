# Ansible

## Creating roles

Roles often have a few directories:

- tasks
- handlers
- templates
- files
- vars
- defaults

A quick way to create these directories is shown below:

```sh
mkdir -p myrole/{tasks,handlers,templates files,vars, defaults}
```

Commas are necessary; you won't be able to create the directories if you use a different delimeter.

## Creating Ansible modules

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
  
  ```sh
  error: Cannot access storage file '/tmp/test-centos/cloud-init.iso': No such file or directory
  ```

  Then eject the CDROM.

  ```
  sudo virsh change-media test-centos sda --eject
  ```
