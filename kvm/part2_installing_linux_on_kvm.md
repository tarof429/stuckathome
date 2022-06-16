# Installing Linux on KVM

## Installing CentOS 7

First download the ISO from the cloest mirror at https://www.centos.org/download/ and copy it to /var/lib/libvirt/boot.

Next, install tigervnc.

```bash
sudo pacman -S tigervnc
```

Secure the vncserver. This will ask for a password. You do not need to specify a view-only pasword.

```
vncpasswd
```

Note that this step only needs to be done once.

Note that all these commands should be run as non-root.

Next, start vncserver

```bash
vncserver :1
```

Launch a VM

```
 sudo virt-install \
--virt-type=kvm \
--name centos7 \
--ram 2048 \
--vcpus=1 \
--os-variant=centos7.0 \
--cdrom=/var/lib/libvirt/boot/CentOS-7-x86_64-Minimal-2009.iso \
--network=bridge=br0,model=virtio \
--graphics vnc \
--disk path=/var/lib/libvirt/images/centos7.qcow2,size=40,bus=virtio,format=qcow2
```

virt-viewer immmediately shows the CentOS 7 install spalash screen. This is fine if we have access to the display directly. However, to connect to the display remotely, we also need to do SSH tunneling.

```
$ sudo virsh dumpxml centos7 |grep vnc
[sudo] password for taro: 
    <graphics type='vnc' port='5900' autoport='yes' listen='127.0.0.1'>

ssh taro@localhost -L 5900:127.0.0.1:5900
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

```
 sudo virt-install \
--virt-type=kvm \
--name alma85 \
--ram 2048 \
--vcpus=2 \
--os-variant=almalinux8 \
--cdrom=/var/lib/libvirt/boot/AlmaLinux-8.5-x86_64-minimal.iso \
--network=bridge=br0,model=virtio \
--graphics vnc \
--disk path=/var/lib/libvirt/images/alma85.qcow2,size=40,bus=virtio,format=qcow2
```

Note that with Alma Linux, yum is still available, but you can use `dnf` as a drop-in replacment.

  ```
  dnf update
  ```

Morever, AlmaLinux 8.5 has been superseded by 8.6. Follow the instructions at https://wiki.almalinux.org/release-notes/8.6.html#installation-instructions to do the upgrade



## Installing CentOS 7 Using Anaconda (kickstart)s

First, install cdrtools.

```
pacman -S cdrtools
```

Next, copy files/centos/anaconda-ks.cfg to /root/anaconda-ks.cfg.

Finally we can install the VM.

```
sudo virt-install \
--virt-type=kvm \
--name myvm \
--ram 4096 \
--vcpus=2 \
--os-variant=centos7.0 \
--location=/var/lib/libvirt/boot/CentOS-7-x86_64-Minimal-2009.iso \
--network=bridge=br0,model=virtio \
--graphics none \
--console=pty,target_type=serial \
--disk path=/var/lib/libvirt/images/myvm.qcow2,size=40,bus=virtio,format=qcow2 \
--initrd-inject=/root/anaconda-ks.cfg \
-x "ks=file:/anaconda-ks.cfg" \
--extra-args "console=ttyS0 serial"
```

This method won't ask any questions.

## Installing Ubuntu using Cloud-Init

Another method for automated installation involves using the Cloud Init image. The example below installs Ubuntu.

1. First install some packages.

  ```
  pacman -S cloud-init cloud-image-utils mkpasswd
  ```

The mkpasswd program is usde to generate the hashed password. See https://aur.archlinux.org/packages/mkpasswd.

2. Next, download the latest cloud init image from https://cloud-images.ubuntu.com/releases/21.10/release/. The file name is `ubuntu-21.10-server-cloudimg-amd64.img`. 

3. Move it to /var/lib/libvirt/boot

    ```
    sudo mv ubuntu-21.10-server-cloudimg-amd64.img /var/lib/libvirt/boot/
    ```

4. Create VMs using the script `ubuntu/files/create_ubuntu_kvm.sh` For example:

  ```
   sh ./create_seeded_ubuntu_vm.sh  -n test-ubuntu -i 192.168.0.30 -u ubuntu -p pass123 -s 40G
   ```

3. Once the macine is up, you can login via console. You might want to update packages by running `apt update` and `apt upgrade`.

## Installing CentOS using Cloud-Init

1. Download https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2 and move it to /var/lib/libvirt/images

2. Now run `create_seeded_centos_vm.sh `.

  ```
  sh ./create_seeded_centos_vm.sh  -n test-centos -i 192.168.0.15 -u centos -p pass123 -s 40G
  ```

## References

https://cloudinit.readthedocs.io/en/latest/topics/examples.html
