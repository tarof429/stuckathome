# Partitioning

Linux should always be intalled on multiple partitions. Doing so increases the maintainability of the system. Below is a simple UEFI/GPT layout:

```
/boot 300 MB
swap 32 GB
/ 512 GB
/home remainder of the disk
```

Since we need 4 partitions, we can create primary partitions. If we needed more, then we would need to create an extended partition.

Below is one example:

1. Next, create a partition table.

    ```
    sudo parted -s /dev/nvme0n1 mklabel gpt
    ```

2. Create the boot partition

    ```
    sudo parted -s /dev/nvme0n1
    mkpart primary fat32 1MiB 300MiB 1 EFI
    set 1 esp on
    ```

3. Create the root partion

    ```
    mkpart primary ext4 300MIB 500GiB root
    ```

4. Create the swap partition

    ```
    mkpart swap linux-swap 500GiB 532GiB swap
    sudo parted set 3 swap on
    ```

5. Create the home partition

    ```
    mkpart primary ext4 532GiB 100% home
    ```

6. Rename partitions

    ```
    name 1 EFI
    name 2 root
    name 3 swap
    name 4 home
    ```

7. Create the partitions

    ```
    mkfs.fat -F 32 /dev/nvm0n1p3
    mkfs.ext4 /dev/nvme0n1p2
    mkfs.ext4 /dev/nvme0n1p4
    ```


## References

https://wiki.archlinux.org/title/partitioning

https://wiki.archlinux.org/title/Parted