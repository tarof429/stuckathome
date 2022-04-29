# Part 4: Creating Ubuntu VMs using KVM

## Steps

1. First will download the latest cloud init image from https://cloud-images.ubuntu.com/releases/21.10/release/. The file name is `ubuntu-21.10-server-cloudimg-amd64.img`. 

2. Move it to /var/lib/libvirt/boot

    ```
    sudo mv ubuntu-21.10-server-cloudimg-amd64.img /var/lib/libvirt/boot/
    ```

3. Create VMs using the script `files/create_ubuntu_kvm.sh` or `create_seeded_ubuntu_vm.sh `. For example, the following will create a VM with IP 192.168.0.15.

    ```
    sh ./create_seeded_ubuntu_vm.sh -n test -u test -p secret -i 192.168.0.16 -g 192.168.0.1 -s 30G
    ```

    As another example, we can create a VM called `kube-master`:

    ```
    sh ./create_seeded_ubuntu_vm.sh -n kube-master -u ubuntu -p secret -i 192.168.0.15 -g 192.168.0.1 -s 30G
    ```

## References

https://fabianlee.org/2020/02/23/kvm-testing-cloud-init-locally-using-kvm-for-an-ubuntu-cloud-image/