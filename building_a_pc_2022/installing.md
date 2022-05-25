# Installing

Since all the partitioning was done in the previous step, we should now proceed to intall ArchLinux.

- The ISO was burned to a USB using Balena Etcher. 

- System clock was updated by running `timedatectl set-ntp true`

- Partitions were all mounted:

    ```
    mount /dev/nvme0n1p2 /mnt
    mount --mkdir /dev/nvme0n1p1 /mnt/boot
    mount --mkdir /dev/nvme0n1p4 /mnt/home
    swapon /dev/nvme0n1p3
    ```

- Installed essential packages by running:

    ```
    pacstrap /mnt base linux-lts linux-firmware netctl
    ```

- Generated fstab by running `genfstab -U /mnt >> /mnt/etc/fstab` (you can preview the contents by not redirecting the output)

- Set time to UTC: `ln -sf /usr/share/zoneinfo/UTC /etc/localtime`

- Install vim: `pacman -S vim`

-  ln -sf /usr/share/zoneinfo/UTC /etc/localtime

- Edited /etc/locale.gen, uncommented en_US.UTF-8 UTF-8 and run locale-gen

- Created /etc/locale.conf with the line LANG=en_US.UTF-8

- Set the hostname in /etc/hostname

- Install more packages: pacman -S vi man-db man-pages

- Edit hosts file:

    ```
    127.0.0.1	localhost
    ::1	    	localhost
    ```

- Configure static IP

    ```
    $ cat /etc/netctl/enp4s0
    Interface=enp4s0
    Connection=ethernet
    IP=static
    Address=('192.168.0.22/24')
    Gateway='192.168.0.1'
    DNS=('8.8.8.8')
    ```

- Set the password for the root account by running passwd

- Install Grub bootloader:

    ```
    pacman -S grub efibootmgr
    mkdir /bot/efi
    ```

- Mount the ESP parttion

    ```
    mount /dev/nvme0n1p1 /boot/efi
    systemctl daemon-reload
    ```

- Install grub:

    ```
    grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
    ```

- Generate grub.cfg

    ```
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

- Install sudo

    ```
    pacman -S sudo
    ```

- Exit from the chroot by typing `exit`

- Unmount /mnt by running `umount -l /mnt`

- Shutdown the machine by running `/sbin/shutdown -h now`


# References

https://wiki.archlinux.org/title/installation_guide

https://itsfoss.com/install-arch-linux/

