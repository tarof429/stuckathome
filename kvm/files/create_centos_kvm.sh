#!/bin/bash

# Based on https://fabianlee.org/2020/03/14/kvm-testing-cloud-init-locally-using-kvm-for-a-centos-cloud-image/

if [ "$#" -ne 2 ];
then
 echo "create_centos_kvm.sh <VM name> <size>"
 echo "Example: create_centos_kvm.sh cobbler 40G"
 exit 0
fi

vmname="$1"
size="$2"

# Copy the generic cloud image
sudo cp /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud-2009.qcow2 \
  /var/lib/libvirt/boot/snapshot-${vmname}-cloudimg.qcow2

# Resize the cloud image
sudo qemu-img resize /var/lib/libvirt/boot/snapshot-${vmname}-cloudimg.qcow2 $size

sudo virt-install --name $vmname --virt-type kvm --memory 4098 --vcpus 2 \
  --boot hd,menu=on \
  --cloud-init root-password-file=$HOME/root_password.txt,disable=on \
  --disk path=/var/lib/libvirt/boot/snapshot-${vmname}-cloudimg.qcow2,device=disk \
  --graphics none \
  --console=pty,target_type=serial \
  --os-type Linux --os-variant centos7.0 \
  --network=bridge=br0,model=virtio