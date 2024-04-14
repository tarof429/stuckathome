# Installing Linux on KVM

## Introduction

There are several ways to install Linux on a KVM:

- manual
- Automated using kickstart
- vagrant
- cloud-init

## Pre-requisites

Since we need acces to the VM's console, install tigervnc and virt-viewer

```bash
sudo pacman -S tigervnc virt-viewer
```

Secure the vncserver. This will ask for a password. You do not need to specify a view-only pasword. As normal user, run:

```
vncpasswd
```

On your home system, setting a view-only password is optional.

Next, start vncserver (if it isn't running already)

```bash
vncserver :0
```

## Manually Instaling Linux

Next, we will install Linux manually using an ISO.

### Installing CentOS 7

First download the ISO from the cloest mirror at https://www.centos.org/download/ and copy it to /data/libvirt/boot.

Launch a VM

```sh
 sudo virt-install \
--virt-type=kvm \
--name centos7 \
--ram 2048 \
--vcpus=2 \
--os-variant=centos7.0 \
--cdrom=/data/libvirt/default/boot/CentOS-7-x86_64-Minimal-2009.iso \
--network=bridge=br0,model=virtio \
--graphics vnc \
--disk path=/data/libvirt/default/images/centos7.qcow2,size=40,bus=virtio,format=qcow2
```

virt-viewer immmediately shows the CentOS 7 install spalash screen. This is fine if we have access to the display directly. However, to connect to the display remotely, we also need to do SSH tunneling.

```
$ sudo virsh dumpxml centos7 |grep vnc
    <graphics type='vnc' port='5900' autoport='yes' listen='127.0.0.1'>
```

Then run do SSH tunneling from the remote machine.

```
ssh localhost -L 5900:127.0.0.1:5900
```

In another terminal, start vncviewer and set the VNC server to localhost:5900. 

```
vncviewer
```

From here, we can proceed to manually install CentOS 7.

## Installing Alma Linux 8

First download the ISO from the cloest mirror at https://mirrors.almalinux.org/isos/x86_64/8.5.html and copy it to /var/lib/libvirt/boot.

Launch a VM. To get the correct OS variant, run:

```
virt-install --os-variant list|grep alma
```

Then run:

```sh
 sudo virt-install \
--virt-type=kvm \
--name alma89 \
--ram 2048 \
--vcpus=2 \
--os-variant=almalinux8 \
--cdrom=/data/libvirt/default/boot/AlmaLinux-8.9-x86_64-minimal.iso \
--network=bridge=br0,model=virtio \
--graphics vnc \
--disk path=/data/libvirt/default/images/alma89.qcow2,size=40,bus=virtio,format=qcow2
```

Note that with Alma Linux, yum is still available, but you can use `dnf` as a drop-in replacment.

```sh
dnf update
```

## Automated install using kickstart

### Installing CentOS 7 Using Kickstart

Redhat-based Linux generates a kickstart file that can be used to automatically install the OS. 


First, install cdrtools.

```
pacman -S cdrtools
```

Next, install CentOS 7 manually. Once the OS is booted up, you can copy /root/anaconda-ks.cfg to your localhost. A sample is provided at files/centos/anaconda-ks.cfg, which you can copy to /root/anaconda-ks.cfg.

Finally we can install the VM.

```sh
sudo virt-install \
--virt-type=kvm \
--name myvm \
--ram 4096 \
--vcpus=2 \
--os-variant=centos7.0 \
--location=/data/libvirt/default/boot/CentOS-7-x86_64-Minimal-2009.iso \
--network=bridge=br0,model=virtio \
--graphics none \
--console=pty,target_type=serial \
--disk path=/data/libvirt/default/images/myvm.qcow2,size=40,bus=virtio,format=qcow2 \
--initrd-inject=/root/anaconda-ks.cfg \
-x "ks=file:/anaconda-ks.cfg" \
--extra-args "console=ttyS0 serial"
```

This method won't ask any questions.

### Installing Ubuntu using Cloud-Init

Another method for automated installation involves using the Cloud Init image. The example below installs Ubuntu.

1. First install some packages.

```sh
pacman -S cloud-init cloud-image-utils
```

You also need to install mkpasswd2. This package is used to generate the hashed password. See https://aur.archlinux.org/mkpasswd2-git.

2. Next, download the latest LTS cloud init image for Ubuntu. For example, Jammy Jellyfish is at https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img. 

```sh
wget https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img
```

3. Move it to /data/libvirt/default/boot

```sh
sudo mv ubuntu-22.04-server-cloudimg-amd64.img /data/libvirt/default/boot/
```

4. Create VMs using the script `ubuntu/files/create_ubuntu_kvm.sh` which is a thin wrapper around virt-install to use cloud-init. For example:

```sh
sh ./create_seeded_ubuntu_vm.sh  -n test-ubuntu -i 192.168.1.30 -u ubuntu -p pass123 -s 40G
```

5. You can login with user `ubuntu`. The VM will already have your public key so there is no need to type in a password if using SSH.

6. You might want to update packages by running `apt update` and `apt upgrade`.

### Installing CentOS using Cloud-Init

1. Download https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2 and move it to /data//libvirt/default/boot

2. Now run `create_seeded_centos_vm.sh `.

```sh
sh ./create_seeded_centos_vm.sh  -n test-centos -i 192.168.0.15 -u centos -p pass123 -s 40G
```

### Installing CentOS using Vagrant

Vagrant makes it easy to launch VMs. We can even make use of libvirtd instead of VirtualBox as the provider.

First, install the vagrant package.

```sh
sudo pacman -S vagrant
```

Next, install plugins needed by vagrant. 

```sh
VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1 vagrant plugin install vagrant-libvirt
```

Add the centos/7 box with the libvirt provider.

```sh
$ vagrant box add centos/7 --provider=libvirt
==> box: Loading metadata for box 'centos/7'
    box: URL: https://vagrantcloud.com/centos/7
==> box: Adding box 'centos/7' (v2004.01) for provider: libvirt
    box: Downloading: https://vagrantcloud.com/centos/boxes/7/versions/2004.01/providers/libvirt.box
Download redirected to host: cloud.centos.org
    box: Calculating and comparing box checksum...
==> box: Successfully added box 'centos/7' (v2004.01) for 'libvirt'!
```

This steps only needs to be done once.

Afterwards, you just need to bring up the VM. An example is provided in the files/centos/vagrant_simple_server directory.

```sh
cd files/centos/vagrant/simple_server
vagrant up
```

Then SSH to it.

```sh
vagrant ssh
```

The VM has a very simple disk layout.

```
[vagrant@localhost ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        1.9G     0  1.9G   0% /dev
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           1.9G  8.5M  1.9G   1% /run
tmpfs           1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/vda1        40G  3.0G   38G   8% /
tmpfs           379M     0  379M   0% /run/user/1000
```

After creating this VM, you may want to know what this means in virsh terms.

```
$ sudo virsh list --all
 Id   Name                    State
----------------------------------------
 -    simple_server_default   running
```

Presumably, 'default' is the name of the network which can be overriden by specifying a value for `libvirt_network_name`.

To shutdown the VM run `sudo vagrant halt`.
```

After creating this VM, you may want to know what this means in virsh terms.


```sh
$ sudo virsh list --all
 Id   Name                    State
----------------------------------------
 -    simple_server_default   running
```

Presumably, 'default' is the name of the network which can be overriden by specifying a value for `libvirt_network_name`.

To shutdown the VM run `sudo vagrant halt`.

## Conclusion

KVM can be installed interactively using virt-install. Two automated methods include cloud-init and vagrant. 

## References