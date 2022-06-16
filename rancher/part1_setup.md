# Installing Rancher on KVM

The following steps creates a 3 node Kubernetes cluster using KVM.

1. Create the kubemaster
    
    ```
    sh ./create_seeded_ubuntu_vm.sh  -n kubemaster -i 192.168.0.30 -u ubuntu -p pass123 -s 40G
    ```

2. Create the kubenodes

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n kubenode01 -i 192.168.0.31 -u ubuntu -p pass123 -s 40G
    sh ./create_seeded_ubuntu_vm.sh  -n kubenode02 -i 192.168.0.32 -u ubuntu -p pass123 -s 40G
    ```

sudo xorriso -as genisoimage -output cloud-init.iso -volid CIDATA -joliet -rock user-data meta-data

sudo cp -f /var/lib/libvirt/boot/ubuntu-21.10-server-cloudimg-amd64.img \
  snapshot-myvm-cloudimg.qcow2


sudo virt-install --name myvm --virt-type kvm --memory 2048 --vcpus 1 \
  --boot hd,menu=on \
  --disk path=cloud-init.iso,device=cdrom \
  --disk path=snapshot-myvm-cloudimg.qcow2,device=disk \
  --graphics none \
  --console=pty,target_type=serial \
  --os-variant ubuntu21.10 \
  --network=bridge=br0,model=virtio
