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
    sudo parted -s /dev/sda mklabel gpt
    ```

2. Create the boot partition

    ```
    sudo parted -s /dev/sda mkpart "EFI" fat32 1MB 301MB
    sudo parted set 1 esp on
    ```

3. Create the root partion

    ```
    sudo parted -s /dev/sda mkpart "root" ext4 301MB 500GB
    ```

4. Create the swap partition

    ```
    sudo parted -s /dev/sda mkpart "swap" linux-swap 500GB 532GB
    sudo parted set 2 swap on
    ```

5. Create the home partition

    ```
    sudo parted -s /dev/sda mkpart "home" primary ext4 532GB 100%
    ```

## References

https://wiki.archlinux.org/title/partitioning

https://wiki.archlinux.org/title/Parted