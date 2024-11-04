# Managing KVM

## Increase the disk size

### Step 1: Shutdown the VM

```sh
sudo virsh shutdown test
```

## Extend the disk

Locate the disk path

```sh
 sudo virsh domblklist test
 Target   Source
--------------------------------------------------------------
 vda      /data/libvirt/default/boot/snapshot-test-cloudimg.qcow2
 sda      -
```

Resize the disk

```sh
sudo qemu-img resize /data/libvirt/default/boot/snapshot-test-cloudimg.qcow2 +5G
Image resized.
```

Start the VM

```sh
sudo virsh start test
Domain 'test' started
```

Check the new layout

```sh
# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom  
vda    253:0    0   30G  0 disk 
└─vda1 253:1    0   25G  0 part /
```

Extend the partition within the guest.

```sh
lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom  
vda    253:0    0   30G  0 disk 
└─vda1 253:1    0   25G  0 part /

[root@localhost ~]# sudo growpart /dev/vda 1
CHANGED: partition=1 start=2048 old: size=52426719 end=52428767 new: size=62912479 end=62914527

[root@localhost ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom  
vda    253:0    0   30G  0 disk 
└─vda1 253:1    0   30G  0 part /
```

Finally resize /

```sh
root@localhost ~]# sudo xfs_growfs /
meta-data=/dev/vda1              isize=512    agcount=13, agsize=524224 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=6553339, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 6553339 to 7864059

[root@localhost ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        1.9G     0  1.9G   0% /dev
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           1.9G   17M  1.9G   1% /run
tmpfs           1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/vda1        30G  1.6G   29G   6% /
tmpfs           379M     0  379M   0% /run/user/0

[root@localhost ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom  
vda    253:0    0   30G  0 disk 
└─vda1 253:1    0   30G  0 part /
```

## Shutdown guests on reboot

Create a file at /etc/default/libvirt-guests with the following content:

```sh
ON_SHUTDOWN=shutdown
SHUTDOWN_TIMEOUT=300
```

See the manpage for libvirt-guests.

## Check storage pools

```sh
sudo journalctl -b
sudo virsh pool-list --all
sudo virsh pool-undefine <pool>
```

## Renaming VMs

If you happen to create a VM with a name you don't like, you can rename it.

```sh
virsh domrename oldname newname
```

## Creating snapshots

```sh
virsh snapshot-create-as --domain <vm> --name <snapshot name>
```

For example:

```sh
sudo virsh snapshot-create-as --domain rocky9-test --name before-createrepo
```

## Listing snapshots

```
sudo virsh snapshot-list <vm>
```

## Reverting to a snapshot

```
sudo virsh --domain <vm>
sudo virsh snapshot-revert --domain <vm> --snapshotname <snapshot name>

## Deleting snapshots

```
sudo virsh snapshot-delete --domain <vm> --snapshotname <snapshot name>
```

## Deleting VMs

First, make sure the VM is shut down.

```
sudo virsh destroy <vm>
```

Then undefine the VM.

```
sudo virsh undefine <vm>
```

This doesn't remove the backing store for the VM however. To do that:

```
sudo virsh undefine <vm> --remove-all-storage
```


## Adding disks

Here's how to create  a disk in the qcow2 format. If you don't specify `preallocation=full` the disk creation will be faster but will occupy less space on the host.

```sh
sudo qemu-img create -f qcow2 /data/libvirt/default/images/rocky9-test-data.qcow2 5G -o preallocation=full
Formatting '/data/libvirt/default/images/rocky9-test-data.qcow2', fmt=qcow2 cluster_size=65536 extended_l2=off compression_type=zlib size=5368709120 lazy_refcounts=off refcount_bits=16
```

Next, we'll attach the disk to the VM. 


```sh
sudo virsh attach-disk --domain rocky9-test /data/libvirt/default/images/rocky9-test-data.qcow2 vdb --persistent --config
```

To detach:

```sh
sudo virsh detach-disk --domain rocky9-test /data/libvirt/default/images/rocky9-test-data.qcow2 --persistent --config
```

## References

https://computingforgeeks.com/how-to-extend-increase-kvm-virtual-machine-disk-size/

https://computingforgeeks.com/resize-ext-and-xfs-root-partition-without-lvm/

https://blog.wirelessmoves.com/2022/08/proper-shutdown-of-vms-on-host-reboot.html

https://bgstack15.wordpress.com/2017/09/22/create-attach-detach-disk-to-vm-in-kvm-on-command-line/
