# Installing

Since all the partitioning was done in the previous step, we should now proceed to install ArchLinux.

- The ISO was burned to a USB using Balena Etcher. 

- System clock was updated by running `timedatectl set-ntp true`

- Partitions were all mounted:

    ```
    mount /dev/nvme0n1p2 /mnt
    mount --mkdir /dev/nvme0n1p1 /mnt/boot
    mount --mkdir /dev/nvme0n1p4 /mnt/home
    swapon /dev/nvme0n1p3
    ```

    If using RAID:

    ```
    mount /dev/nvme0n1p3 /mnt
    mount --mkdir /dev/nvme0n1p1 /mnt/boot
    mkswap /dev/nvme0n1p2
    swapon /dev/nvme0n1p2
    mount --mkdir /dev/VolGroupArray/lvdata /mnt/data
    mount --mkdir /dev/VolGroupArray/lvhome /mnt/home

    ```

- Install essential packages by running:

    ```
    pacstrap /mnt base linux-lts linux-firmware netctl
    ```

    Note that the above command installs the LTS kernel; replace this with `linux` if you want to install the latest stable kernel.

- Generated fstab by running `genfstab -U /mnt >> /mnt/etc/fstab` (you can preview the contents by not redirecting the output)

- chroot: `arch-chroot /mnt`

- Set time to UTC: `ln -sf /usr/share/zoneinfo/UTC /etc/localtime`

- Install vim: `pacman -S vim`

- If using RAID with LVM, be sure to add mdadm_udev and lvm2 to /etc/mkinitcpio.conf after udev; see https://wiki.archlinux.org/title/LVM_on_software_RAID. 


- See https://wiki.archlinux.org/title/locale for setting up locale.

- Set the hostname in /etc/hostname

- Install more packages: `pacman -S man-db man-pages`

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
    Address=('192.168.1.20/24')
    Gateway='192.168.1.1'
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
    systemctl daemon-reload (failed?)
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

- If using RAID,

    ```
    pacman -S lvm2 mdadm
    ```

- Eable systemd-networkd

    ```
    systemctl enable systemd-networkd
    systemctl start systemd-networkd
    ```

- Enable systemd-reolved

    ```
    systemctl enable systemd-resolved
    systemctl start systemd-resolved
    ```

- Exit from the chroot by typing `exit`

- Unmount /mnt by running `umount -l /mnt`

- Shutdown the machine by running `/sbin/shutdown -h now`


# References

https://wiki.archlinux.org/title/installation_guide

https://itsfoss.com/install-arch-linux/

