# Vagrant with QEMU and KVM

## Introduction

In this tutorial, we will use Vagrant to manage virtual machines running on top of KVM, a hypervisor built into the Linux kernel. Qemu is used to virtualize machines.

## Preqrequisites

Install the vagrant package

```
sudo pacman -S vagrant
```

Next, install plugins.

```
sudo vagrant plugin install vagrant-vbguest vagrant-share vagrant-libvirt
```

## Create a VM

Add the centos/7 box with the libvirt provider.

```
sudo vagrant box add centos/7 --provider=libvirt
==> box: Loading metadata for box 'centos/7'
    box: URL: https://vagrantcloud.com/centos/7
==> box: Adding box 'centos/7' (v2004.01) for provider: libvirt
    box: Downloading: https://vagrantcloud.com/centos/boxes/7/versions/2004.01/providers/libvirt.box
Download redirected to host: cloud.centos.org
    box: Calculating and comparing box checksum...
==> box: Successfully added box 'centos/7' (v2004.01) for 'libvirt'!
```

This steps only needs to be done once.

Afterwards, you just need to bring up the VM. An example is provided in the files/simple_server directory.

```
sudo vagrant up
```

Then SSH to it.

```
vagrant ssh
```

After creating this VM, you may want to know what this means in virsh terms.

```
$ sudo virsh list --all
 Id   Name                    State
----------------------------------------
 -    simple_server_default   shut off
```

Presumably, 'default' is the name of the network which can be overriden by specifying a value for `libvirt_network_name`.

To shutdown the VM run `sudo vagrant halt`.

## Creating a Vagrant image with multiple partitions

Launch a VM and do a manual installation.

```
 sudo virt-install \
--virt-type=kvm \
--name centos7 \
--ram 2048 \
--vcpus=1 \
--os-variant=centos7.0 \
--cdrom=/var/lib/libvirt/boot/CentOS-7-x86_64-Everything-2009.iso \
--network=bridge=br0,model=virtio \
--graphics vnc \
--disk path=/var/lib/libvirt/images/multi_partitions.qcow2,size=40,bus=virtio,format=qcow2
```

We're going to specify a disk size of 20GiB for /, and create a second partion for /var and give it the rest of the disk space.

Enable DHCP for the eth0 netowrk device.

We're also going to create a user called vagrant with password vagrant. Don't set the password for root user.

After rebooting the VM, login as vagrant.

Create a file to allow vagrant user to run sudo commands without a password prompt.

```
sudo visudo -f /etc/sudoers.d/vagrant
```

and paste

```
vagrant ALL=(ALL) NOPASSWD:ALL
```

Install wget. 

```
sudo yum install -y wget
```

The put the SSH key from vagrant user.

```
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
wget --no-check-certificate \
https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
-O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
```

Restart the SSH service.

```
sudo systemctl restart sshd
```

Shutdown the VM.


Create a directory under /tmp

```
mkdir /tmp/multi_partitions
```

Copy the qcow2 image to this directory.

```
sudo cp /var/lib/libvirt/images/multi_partitions.qcow2 /tmp/multi_partitions/box.img
```

Copy the files under `server_with_partitions` to this directory.

```
cd vagrant_qemu_kvm/files/server_with_partitions

sudo cp * /tmp/multi_partitions
```

Tar the files.

```
cd /tmp/multi_partitions
sudo tar czf multi_partitions.box ./metadata.json ./Vagrantfile ./box.img
```

This can take a few minutes!

Next, add the box to Vagrant.

```
sudo vagrant box add --name multi_partitions multi_partitions.box
```

Now you should be able to create the VM using vagrant. Create a directory under /tmp.

```
mkdir /tmp/myvm
cd /tmp/myvm
sudo vagrant init multi_partitions
```

Now you should be able to bring up the VM.

```
sudo vagrant up
```

This last step will upload the base box image as a volume into libvirt storage.

After the VM comes up (which for some reason can take a very long time ~20 minutes), you can SSH to the VM as you normally would.

```
sudo vagrant ssh
```

## References

https://wiki.archlinux.org/title/Vagrant#vagrant-libvirt

https://github.com/vagrant-libvirt/vagrant-libvirt#create-box

https://openattic.org/posts/how-to-create-a-vagrant-vm-from-a-libvirt-vmimage/

https://unix.stackexchange.com/questions/222427/how-to-create-custom-vagrant-box-from-libvirt-kvm-instance