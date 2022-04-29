# Part 2: Automating KVM install

## Automated CentOS 7 installation using anaconda

First, install cdrtools.

```
pacman -S cdrtools
```

Next, copy files/anaconda-ks.cfg to /root/anaconda-ks.cfg.

Finally we can install the VM.

```
sudo virt-install \
--virt-type=kvm \
--name tc-kvm01-vm01 \
--ram 4096 \
--vcpus=2 \
--os-variant=centos7.0 \
--location=/var/lib/libvirt/boot/CentOS-7-x86_64-Minimal-2009.iso \
--network=bridge=br0,model=virtio \
--graphics none \
--console=pty,target_type=serial \
--disk path=/var/lib/libvirt/images/tc-kvm01-vm01.qcow2,size=40,bus=virtio,format=qcow2 \
--initrd-inject=/root/anaconda-ks.cfg \
-x "ks=file:/anaconda-ks.cfg" \
--extra-args "console=ttyS0 serial"
```

An alternative is to use cloud-init, described below.

## Using cloud-init

Cloud-init is a feature of KVM that allows us to quickly provision VMs.

First, download the cloud linux qcow2 image from https://cloud.centos.org/centos/7/images/ and copy it to /var/lib/libvirt/boot.

Next, create a snapshot of our cloud image with expanded storage.

```
sudo qemu-img create -b /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud-2009.qcow2 -f qcow2 /var/lib/libvirt/boot/snapshot-test-cloudimg.qcow2 30G
```

Next, customize our image.

```
{
sudo virt-customize -a /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud-2009.qcow2 --root-password password:pass123

sudo virt-customize -a /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud-2009.qcow2 \
  --copy-in files/ifcfg-eth0:/etc/sysconfig/network-scripts

sudo virt-customize -a /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud-2009.qcow2 \
  --copy-in files/network:/etc/sysconfig

sudo virt-customize -a /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud-2009.qcow2 \
  --timezone "America/Los_Angeles"

sudo virt-customize -a /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud-2009.qcow2 \
  --firstboot-command "yum -y update && sleep 5 && reboot"
}
```

Now we can bring up our VM.

```
sudo virt-install \
--connect qemu:///system \
--virt-type=kvm \
--name tc-kvm01-vm01 \
--ram 4096 \
--vcpus=2 \
--os-variant=centos7.0 \
--network=bridge=br0,model=virtio \
--graphics none \
--console=pty,target_type=serial \
--disk path=/var/lib/libvirt/boot/snapshot-test-cloudimg.qcow2 \
--import
```

Packages will be updated after the VM first comes up, so wait to login until after it reboots. You can login diretly via the console, or using SSH using the provided root credentials.

## Using cloud-init in a script

For convenience, the `create_centos_kvm.sh` can be used to quickly create VMs. For example:

```
sh files/create_centos_kvm.sh test 20G
```

will create a CentOS VM called `test` with 20GB of disk space (of which not all is actually allocated to /). 

The VM will automatically install some packages and reboot. Afterwards you can login as root.

## Useful virsh commands

To shutdown the VM, run:

```
sudo virsh shutdown test
```

To start the VM, run:

```
sudo virsh start test
```

To get access to the console, run:

```
sudo virsh console test
```