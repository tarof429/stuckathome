# Part 2: Automating KVM install

## Using cloud-init

Note: these steps no longer work with the latest ArchLinux.

Cloud-init is a feature of KVM that allows us to quickly provision VMs.

Next, download the cloud linux qcow2 image from https://cloud.centos.org/centos/7/images/ and copy it to /var/lib/libvirt/boot.

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

or `create_seeded_ubuntu_vm.sh `. For example, the following will create a VM with IP 192.168.0.15.

    ```
    sh ./create_seeded_ubuntu_vm.sh -n test -u test -p secret -i 192.168.0.16 -g 192.168.0.1 -s 30G
    ```

    As another example, we can create a VM called `kube-master`:

    ```
    sh ./create_seeded_ubuntu_vm.sh -n kube-master -u ubuntu -p secret -i 192.168.0.15 -g 192.168.0.1 -s 30G
    ```

## References

https://fabianlee.org/2020/02/23/kvm-testing-cloud-init-locally-using-kvm-for-an-ubuntu-cloud-image/