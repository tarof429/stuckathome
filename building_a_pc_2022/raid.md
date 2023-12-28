# Installing ArchLinux with RAID

### Introduction
This example creates /, /boot and swap on an m.2 disk and creates RAID 1 on two SSDs for /home.

## Layout

/dev/nvme0n1:

```
/boot 300 MB
swap 16 GB
/ remainder of SSD
```

SSD:

```
/home ramainder of SSD
```

## Note

You do not need to change BIOS settings such as changing from AHCI to RAID. As long as the BIOS can detect two disks we can proceed.

## Installation

### Boot from ArchLinux USB

 Download the latest installer from https://archlinux.org/download/ and burn it to a USB.

### Load kernel modules
 
 ```
 # modprobe raid1
 # modprobe dm-mod
 ```

### Get a list of our disks

Run fdisk and note the names of the block devices
```
fdisk -l
```

### Create Partitions

Create a partition table

```
parted -s /dev/nvme0n1 mklabel gpt
```

Create the boot partition

```
parted /dev/nvme0n1
(parted) mkpart primary fat32 1MiB 300MiB
(parted) set 1 esp on
```

Create the swap partition

```
(parted) mkpart swap linux-swap 300MiB 16GiB
(parted) set 2 swap on
```


Create the root partion

```
(parted) mkpart primary ext4 16GIB 100%
```

Rename partitions

```
(parted) name 1 EFI
(parted) name 2 swap
(parted) name 3 root
```

### Create RAID

Create partition tables

```
parted -s /dev/sda mklabel gpt
parted -s /dev/sdb mklabel gpt
```

The RAID will hold /home and /data.

```
parted /dev/sda
(parted) mkpart primary ext4 1MiB 100%
(parted) exit
```

```
partd /dev/sdb
(parted) mkpart primary ext4 1MiB 100%
(parted) exit
```

Create a RAID at /dev/md0

```
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
```

Create physical volumes

```
pvcreate /dev/md0
```

Create the volume group

```
vgcreate VolGroupArray /dev/md0
```

Confirm that LVM has added the VG with:

```
vgdisplay
```

Create logical volumes

Create a /data LV:

```
lvcreate -L 300G VolGroupArray -n lvdata
```

Create a /home LV:

```
lvcreate -l 100%FREE VolGroupArray -n lvhome
```

Confirm that LVM has added the VG with:

```
lvdisplay
```

### Create the prtitions

```
mkfs.fat -F 32 /dev/nvm0n1p1
mkfs.ext4 /dev/nvme0n1p3
mkfs.ext4 /dev/mapper/VolGroupArray-lvdata
mkfs.ext4 /dev/mapper/VolGroupArray-lvhome
```

### Update RAID configuration

```
# mdadm --examine --scan >> /etc/mdadm.conf
```


### Validate RAID

```
mdadm --query --detail /dev/md127
```

## References

https://wiki.archlinux.org/title/LVM_on_software_RAID

https://bobcares.com/blog/removal-of-mdadm-raid-devices/
