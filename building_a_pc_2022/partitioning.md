# Partitioning

Linux should always be intalled on multiple partitions. Doing so increases the maintainability of the system. Below is a simple UEFI/GPT layout:

```
/boot 1 GB
swap 32 GB
/ remainder of the disk
```

Below are the steps:

1. Start parted

    ```
    sudo parted /dev/sda
    ```

2. Next, create a partition table.

    ```
    sudo parted -s /dev/sda mklabel gpt
    ```

3. Create a boot partition

    ```
    sudo parted -s /dev/sdaprimary ext4 1 1GB
    (parted) set 1 boot on
    ```

3. Create a swap partition

    ```
    (parted) mkpart primary linux-swap 1GB 32GB
    (parted) set 2 swap on
    ```

4. Create a root partion

    ```
    (parted) mkpart primary ext4 32GB 100%
    ```

## References

https://wiki.archlinux.org/title/partitioning