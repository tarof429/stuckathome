# Changing the Kernel

It may seem simple to install a new kernel. After running the LTS kernel for many months, I decided to upgrade to the mainline kernel. After I rebooted, I was stuck at the BIOS menu. Below is the correct procedure.

## Steps

1. Create an emergency disk by burning the ArchLinux ISO to a USB.

2. Boot into the USB

3. Mount the filesystems. 

```
mkdir -p /mnt/boot
mount /dev/nvme0n1p2 /mnt
mount /dev/nvme0n1p1 /mnt/boot
```

3. chroot to /mnt

```
arch-chroot /mnt
```

4. Install grub. Here was the tricky part (at least for me). GRUB needs to be installed in the EFI partition, which in my case was /boot, not some other combination like /boot/efi

```
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

5. Generate grub.cfg

```
grub-mkconfig -o /boot/grub/grub.cfg
```

6. Exit from the chroot

```
exit
```

7. Unmount parttions and reboot

```
umount -l /mnt
/sbin/shutdown -r now
```

## Post Steps

1. I removed the lts kernel and regenerated GRUB.

```
sudo pacman -Rs linux-lts
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

2. I removed /boot.bak which was left over from when I made a backup of /boot when the system couldn't boot and I made a backup of the directory.

3. I remove /boot/efi.bak which was also a backup from when I couldn't boot.