# Managing KVM

## Increase the disk size

### Step 1: Shutdown the VM

```
sudo virsh shutdown test
```

## Extend the disk

Locate the disk path

```
 sudo virsh domblklist test
 Target   Source
--------------------------------------------------------------
 vda      /data/libvirt/default/boot/snapshot-test-cloudimg.qcow2
 sda      -
```

Resize the disk

```
sudo qemu-img resize /data/libvirt/default/boot/snapshot-test-cloudimg.qcow2 +5G
Image resized.
```

Start the VM

```
sudo virsh start test
Domain 'test' started
```

Check the new layout

```
# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom  
vda    253:0    0   30G  0 disk 
└─vda1 253:1    0   25G  0 part /
```

Extend the partition within the guest.

```
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

```
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

```
ON_SHUTDOWN=shutdown
SHUTDOWN_TIMEOUT=300
```

See the manpage for libvirt-guests.

## References

https://computingforgeeks.com/how-to-extend-increase-kvm-virtual-machine-disk-size/

https://computingforgeeks.com/resize-ext-and-xfs-root-partition-without-lvm/

https://blog.wirelessmoves.com/2022/08/proper-shutdown-of-vms-on-host-reboot.html