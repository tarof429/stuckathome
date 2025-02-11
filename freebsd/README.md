# Installing FreeBSD

## Steps

1. Download FreeBSD USB installer to a USB.

2. Burn FreeBSD to a USB. For example:

    ```sh
    sudo dd bs=1M if=FreeBSD-14.1-RELEASE-amd64-memstick.img of=/dev/sdd conv=fsync oflag=direct status=progress
    ```

3. Insert USB, boot the Mac while pressing the Option key, and when you see a disk labeled "EFI Boot", select it and type Enter.

4. A good reference for installing FreeBSD is at https://docs.freebsd.org/en/books/handbook/bsdinstall/#bsdinstall-start. Some tips are:

- Using Guided UFS Disk Setup lets you define multiple partitions

- sshd is only needed if you plan to SSH to the machine

- https://freebsdfoundation.org/wp-content/uploads/2021/07/Seven-Ways-to-Increase-Security-in-a-New-FreeBSD-Installation.pdf has some good notes on hardening FreeBSD

- Install sudo by running `pkg install sudo`. Then add the nonprivileged user to the wheel group: `pw groupmod wheel -m <user>`. 

- To remove packages that are no longer used, run `pkg autoremove`.

- To list kernel modules in use, run `kldstat`. To laod a kernel module, run kldload <module>. 

- To restart the network, run `service netif restart`. 

- Install pciutils to run lspci.

- DHCP for an interface is set in /etc/rc.conf. To restart dhcp on the client, run `service dhclient restart <interface>.

- To use a static IP instead, edit /etc/rc.conf to read:

    ```sh
    ifconfig_em0="inet 192.168.2.20 netmask 255.255.255.0"
    defaultrouter="192.168.1.1"
    ```

    also update /etc/resolv.conf if needed.

    Afterwards:

    ```sh
    service netif restart && service routing restart
    ```

    If your IP is set but you cannot ping any hosts, check the default route.

- To update the system, run:

    ```sh
    freebsd-update fetch
    freebsd-update install
    ```

    See https://docs.freebsd.org/en/books/handbook/cutting-edge/. 

## Notes

- To check battery life, use `apm`.


## References

https://www.netbsd.org/docs/guide/en/index.html

https://docs.freebsd.org/en/books/handbook/network/

https://srobb.net/fbsdquickwireless.html