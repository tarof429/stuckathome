# Introduction

Both VirtualBox and KVM provide a way to create VMs for local development. But if you want to automate the process using tools instead of creating scripts that call out to virt-install or VBoxManage? One solution is to use Vagrant.

## Creating a CentOS VM

To create a CentOS VM, hop on over to https://app.vagrantup.com/boxes/search and search for centos/7. The instructions are to run:

```
vagrant init centos/7
vagrant up
```

If you open the Vagrant file, you'll notice a line that says vm.provider "VirtualBox". This is the default provider that Vagrant uses to create VMs. But what if you could use a different provider like KVM?

## Creating CentOS VMs using the KVM provider

https://www.adaltas.com/en/2018/09/19/kvm-vagrant-archlinux/ has step-by-step instructions for creating CentOS VMs using Vagrant and KVM. For convenience, the Vagrantfile used in that example is in files/libvirt with NO modifications.


## References

https://www.adaltas.com/en/2018/09/19/kvm-vagrant-archlinux/
