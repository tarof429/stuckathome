# Linux Tips

## Introduction

This section covers a variety of topics related to Linux administration and was preparation for the RHCSA exam. 

## Pre-requisites

A VM running Rocky 9 was used as the training environment.

## Users

Use `chage` to change the password expirary per user.

Defaults are stored in /etc/login.defs.

## History

To remove an item from user's history, run history -d <history item>.

## Files and Processes

- To see what files are consuming the most space in a directory such as /var, run: `du -k /var | sort -nr | more`.

- It can be handy to find out the filesystem when running df. To do this, run `df -T`. 

- The `free` command is not very human-friendly by default, but you can change the units easily buy using `m` or simply `-h` for human-readable.

- The `lsof` command can be used to list open files. With no arguments, it's not very helpful. If you know a user is logged into a system, you can find what files he has opened by running `lsof -u <user>`. Or what if you find a process from top and you want to find what files it has opened. For example, if top lists a process called `Isolated Web Co` with PID 16068, then run `lsof -p 16068` will give you a list of files that process has opeened. See https://www.redhat.com/en/blog/analyze-processes-lsof. 

- The `tcpdump` command can be used to troubleshoot networking issues. For example, on host A, run tcpdump -i <interface> host <source IP>. Then from the source IP machine, run ping <ip.of.host.A>. You should see some output on host A indicating that the ping was successful. See https://hackertarget.com/tcpdump-examples/. Note that if you want to monitor port 22, you should login to the server from the console and not from an SSH session.

- A command that shows what gateway traffic is flowing through is netstat. For example, `netstat -nrv`. If you run `netstat -t` you can see the list of outgoing TCP connections.

- Other commands are: vmstat, iostat, iftop.

- To find out detailed information on a file creation time, use `stat <file>`.

## Services

- To check all running services, run `systemctl --all`. 

- To reload configurations of services without restarting it, run `systemctl reload <service name>`. This is useful for services such as httpd or sshd for example. For example, by default sshd does not let the root user SSH into the OS. To enable this behavior, edit /etc/ssh/sshd_config and set the property `PermitRootLogin` to true. Then instead of restarting the service you could just reload the service.

- You can enable/disable services by using mask/unmask. In the case of mask, then the service will be started whether or not it is dependent on another service. If you unmask it, then the service will nto be started as a dependency. 

## SSH

- To make SSH more secure, it is good to set the `ClientAliveInterval` to a value such as 600 or 10 minutes to automatically logout idle SSH sessions. 

- A hidden property is `AllowUsers`. This lets you restrict who can SSH to the server.

## Timezone

- To change the timezone, run `timezonectl list-timezones` to get a list of timezones and then run `timezonectl set-timezone=<timezone>`. 

## Networking

- To get a list of network interfaces, run `nmcli connection`.

- To list all the parameters you can pass to nmcli:

    ```sh
    nmcli connection show # To get the list of interfaces using nmcli
    ```

- To list all the ipv4 parameters you can configure for an interface:

    ```sh
    nmcli connection show enp1s0 | grep ipv4
    ```

- To configure a static IP with nmcli:

    ```sh
    nmcli connection modify enp1s0 ipv4.addresses 192.168.1.201/24
    nmcli connection modify enp1s0 ipv4.gateway 192.168.1.1
    nmcli connection modify enp1s0 ipv4.method manual
    nmcli conneciton modify enp1s0 ipv4.dns 8.8.8.8
    nmcli connection down enp1s0 && nmcli connection up enp1s0
    ip addr show enp1s0
    ```

- It can be handy to just modify all  the settings at once:

  ```sh
   nmcli con modify enp1s0 ipv4.addresses 192.168.1.200/24 ipv4.gateway 192.168.1.1 ipv4.dns "192.168.1.1 1.1.1.1" ipv4.method manual
  ```

  Some key things to remember are:

  - All the variables that need to be modified begin with ipv4.
  - Don't use `=`
  - Don't forget subnet mask
  - Don't forget to specify which interface you want to modify
  - The command can be shortened to `nmcli con mod <interface>`

- To check if the interface is dynamic or static:

    ```sh
    nmcli connection show enp1s0 | grep method
    ```

- To add multiple DNS servers, use quotes and spaces around each server IP.

    ```sh
    nmcli con modify enp1s0 ipv4.dns "1.1.1.1 8.8.8.8"
    ```

- To add a secondary IP:

    ```sh
    nmcli con modify enp1s0 +ipv4.addresses 192.168.1.201/24
    ```

- To reload the configuration (you can do this instead of stop/starting the interface).

    ```sh
    nmcli con reload
    ```

- To remove the secondary IP:

    ```sh
    nmcli con modify enp1s0 -ipv4.addresses 192.168.1.201/24
    ```

- To troubleshoot network connectivity you can use tcpdump.

- A useful tool you can use to troubleshoot DNS issues is nslookup. Install it using bind-utils. 

- Configure firewalls using firewall-cmd, which is available from the firewalld package. If you look at the man page for firewall-cmd, you can see some basic examples at the very bottom (it can help to search for `Example`).

## Packages

- To find what package provides a binary, use `dns provides **/<package name>.

- To see the list of configuration files for a package, use `rpm -qp <package name>.

- To see what package provides a file , use `rpm -qf <path.to.file>`. For example, 
    ```sh
    $ which ssh
    /usr/bin/ssh
    $ sudo rpm -qf /usr/bin/ssh
    openssh-clients-8.7p1-38.el9_4.4.x86_64
    ```
- To create a local YUM repo, follow these steps (for AlmaLinux 9):

    - Install createrepo package
    - Create a directory called /iso
    - Mount the AlmaLinux 9 ISO to /iso
    - Create a directory called /localrepo
    - Create a directory called /localrepo/BaseOS
    - Copy /iso/BaseOS/Packages to /localrepo/BaseOS/Packages
    - Run `createrepo Packages -o`.
    - Create a directory called /localrepo/AppStream
    - Copy /iso/AppStream/Packages to /localrepo/AppStream/Packages
    - Run `createrepo Packages -o .`
    - Go to /etc/yum.repos.d
    - Create a directory called old
    - Move all the *.repo files to old
    - Copy old/rocky.repo to the parent directory
    - Edit this file and point baseurl for the BaseOS and AppStream repositories
    - Finally verify the repostories by running `dnf repolist -v`

- A handy CLI command to know is `dnf config-manager`. For example, to enable a yum repo, run `dnf config-manager --set-enabled baseos`.

- To remove an old kernel, you can use `dnf remove kernel-core-<version.of.kernel.to.remove>`. Then use `dnf autoremove` to delete anything you don't need. The `erase` option is deprecated. Since we only need to explictly remove one package, it is not very helpful to create a variable for the kernel version to remove.

- To see what packages were installed, run `dnf history`. You can undo package installs this way by running `dnf history undo <id>.

## Shells

The list of shells available on a system is listed in /etc/shells.

```sh
$ cat /etc/shells 
# Pathnames of valid login shells.
# See shells(5) for details.

/bin/sh
/bin/bash
/bin/rbash
/usr/bin/sh
/usr/bin/bash
/usr/bin/rbash
/usr/bin/git-shell
/usr/bin/systemd-home-fallback-shell 
```

The current shell is displayed by echoing $0.

```sh
$ echo $0
bash
```

## Shell Scripting

The following script reads user input and does a numerical comparison.

```sh
$ cat numerical_test.sh 
#!/bin/sh

echo -n "Enter a number between 1 and 10: "
read NUM
if [[ $NUM -gt 5 ]]; then
  echo "Number ${NUM} is greater than 5"
else
  echo "Number ${NUM} is less than 5"
 fi
```

The following checks the day of the week and prints a message. Unfortunately the man page for `date` doesn't show an example of formatting the output, but it does list the fields.

```sh
$ cat today.sh 
#!/bin/sh

TODAY=$(date +%a)

if [[ $TODAY == Wed ]]; then
  echo "Backup"
fi
```

Multiple if statements can be tested by separating them with a `||`.

```sh
$ cat !$
cat today_or_tomorrow.sh
#!/bin/sh

TODAY=$(date +%a)

if [[ $TODAY == Wed ]] || [[ $TODAY == Thu ]]; then
  echo "Backup"
fi
```

The `while` loop is a form a a compound command (it is listed under the topic `Compound Commands` in the man page for bash.

```sh
$ cat case.sh 
#!/bin/sh

days=(Sun Mon Tue Wed Thu Fri Sat)
numdays="${#days[@]}"
typeset -i done=0
ans=""

while [[ $done -ne 1 ]]
do
  echo -n "Continue (n/Y) "
  read ans
  case $ans in
  Y)
    done=1
    ;;
  n)
    done=1
    ;;
  esac
done

if [[ $ans == "Y" ]]; then
  num=$(shuf -i 0-${numdays} -n 1)
  echo "Done: ${days[num]}"
f
```

The `grep` command has a `-c` parameter that can return the number of occurences in a file. This can be more convenient that piping the result to `wc`. For example:

```sh
sudo grep -c -i error /var/log/messages
41
```

What if you want to find the number of lines that did not match a pattern? The example below returns the number of lines that did not have the word `error` in /var/log/messages

```sh
$ sudo grep -c -vi error /var/log/messages
14462
```

The `egrep` command has a nifty feature that allows you to search for multiple occurences of a string. For example:

```sh
$ sudo egrep -ci "error|fail" /var/log/messages
```

This is easier than grepping multiple times and trying to addd the results.

```sh
$ sudo grep -ci error /var/log/messages
41
$ sudo grep -ci fail /var/log/messages
44
```

## Scheduling Jobs

To create a crontab, see the syntax in /etc/crontab. 

If you want to use at, first install at and then enable and start the service. 

To schedule a task with at, enter `at` with a time and then enter a command, followed by ^D. For example:

```sh
at 1:15 Thu
warning: commands will be executed using /bin/sh
at> du -sh > /tmp/disk_usage.txt
at> <EOT>
job 6 at Thu Nov  7 01:15:00 2024
```

You can use `atq` to see the list of scheduled tasks. Scheduled tasks can be removed by using `atrm`.

You can also schedule scripts.

```sh
$ at 01:20 PM -f /tmp/myscript.sh
warning: commands will be executed using /bin/sh
job 8 at Thu Oct 31 13:20:00 2024
```

You can schedule jobs based on system usage using `batch`.

```sh
sh ./myscript.sh  | batch
warning: commands will be executed using /bin/sh
job 10 at Thu Oct 31 13:21:00 2024
```

## Logging

By deault, system journals are not persisted across reboots. To keep system journals after a reboot, do the following:

```sh
mkdir -p /var/log/journal
systemd-tmpfiles --create --prefix /var/log/journal
```

These steps are described in the manpage for systemd-journald.

## Performance Tuning

The `tuned` package has a service that can be used to automatically tune performance. This package has a CLI called `tuned-adm` which can be used to list available profiles, see the current profile, and change to a different profile. The profiles are stored in /usr/lib/tuned.

To use tuned, install the `tuned` package.

```sh
sudo dnf install tuned
```

Start the service.

```sh
sudo systemctl enable tuned
sudo systemctl start tuned
```

Run `tuned-adm active` to see the currently active profile.

```sh
$ sudo tuned-adm active
Current active profile: virtual-guest
```

You can switch to a different profile using the `profile` option.

From the cockpit GUI, you can change the profile by going to Overview | Configuration | Performance profile. 

Use `renice` to change the nice value of proceses.

## Access Control lists

- Use `setfacl` to set access control lists for a file, and `getfacl` to get the ACL for a file. For example:

  ```sh
  $ setfacl -m u:taro:r anaconda-ks.cfg # Grants taro read access to this file
  $ setfacl -b anaconda-ks.cfg # Removes ACL from this file
  $ setfacl -mR u:john:rw /home/taro # Recorsively grants rw access to /home/taro to john
  ```

- For example, one use case is to give unprivileged users read access to log files in /var/log.
  - Copy /var/log/secure to /tmp (just for testing)
  - Run `setfacl -m u:taro:r /tmp/secure`
  - Now as user taro I should be able to read /tmp/secure.

## SELinux

- To change the SELinux policy, edit `/etc/selinux/config`.

- To check the SELinux for a file, use `ls -lZ <file>`.

- To check the SELinux for a file, use `ls -DZ <directory>`.

- You can check the SELinux label for a process by running `ps-axZ`. For example:

  ```sh
  $ ps -axZ |grep sshd
  system_u:system_r:sshd_t:s0-s0:c0.c1023 780 ?    Ss     0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
  system_u:system_r:sshd_t:s0-s0:c0.c1023 1321 ?   Ss     0:00 sshd: taro [priv]
  unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 1334 ? S   0:00 sshd: taro@pts/0
  unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 1394 pts/0 S+   0:00 grep --color=auto ss
  ```

- You can check the SELinux label for a socket by running `netstat -tlpnZ`. For example:

  ```sh
  $ sudo netstat -tlpnZ | grep sshd
  tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      780/sshd: /usr/sbin  system_u:system_r:sshd_t:s0-s0:c0.c1023           
  tcp6       0      0 :::22                   :::*                    LISTEN      780/sshd: /usr/sbin  system_u:system_r:sshd_t:s0-s0:c0.c1023         
  ```

- To see the list of SELinux labels that are on, run `getsebool -a`.

- To set an SELinux label, run `setsebool`.

- The `semanage` tool can also manage labels.

- For example, SELinux does not allow HTTP services to connect to FTP servers by default.

  ```sh
  $ getsebool -a | httpd_can_connect_ftp
  httpd_can_connect_ftp --> off
  setsebool httpd_can_connect_ftp 1
  $ sudo getsebool httpd_can_connect_ftp
  httpd_can_connect_ftp --> on
  ```

  You may want to run setsetbool with the `-P` option so that the setting is fixed across reboots.

## How to Break into RedHat Linux

1. Reboot the system. If this is a KVM, run `virsh restart <domain>`.

2. When you see the list of kernels, select one and type `e` for edit. Then go to the end of the kernel arguments and add `rd.break`. If there is any mention of redirecting output to the console, remove it.

## Managing Grub

To list all kernel entries, type `grubby --info=ALL`.

Let's say we have a problem with our KVM in that we don't see the console output. We want to redirect the console output to our terminal. Once we SSH to the server, what we can do is add default arguments to all the kernels.

```sh
grubby --args="console=ttyS0,115200" --update-kernel=ALL
```

Let's say we don't want this argument for the rescue kernel. To remove it, run

```sh
sudo grubby --remove-args="console=ttyS0,115200" --update-kernel="/boot/vmlinuz-0-rescue-e116e6f8824d49d49b3779b59df050c9"
```

It is posible to use --args and --remove-args simultaneously. 


## Managing Disks

### Creating LVM

Given a disk, first use `fdisk` to create a new partition of type LVM. The LVM type is `8e`. 

Once this is created, use `pvcreate` to create a physical volume. 

```sh
pvcreate /dev/vdb1
```

Use `pvdisplay` to display physical volumes.

Next, we'll create the volume group.

```sh
vgcreate data_vg /dev/vdb1
  Volume group "data_vg" successfully create
```

To verify, use `vgdisplay`


```sh
vgdisplay data_vg
```

Next we can create logical volumes. See the manpage for lvcreate for other options.

```sh
lvcreate --name data_lv --size 2042M data_vg
```

To verify, run lvdisplay.

```sh
lvdisplay
```

Now we can go ahead and create the filesystem.

```sh
mkfs.xfs /dev/data_vg/data_lv
```

Afterwards we need to mount it. Remember that we need to mount the logical volume. 

```sh
sudo mount /dev/data_vg/data_lv /data
```

Somet things to note:

- lvcreate's -s option does not stand for size, that option is -L. Using --size might be easier.
- You can skip the name of the logical volume if you want, but it's a good practice to provide a name.
- You can use lvremove to remove logical volumes, but you need to give the path to the logical volume. Example: `sudo lvremove /dev/data_vg/lvol0`

Let's say vdb ran out of disk space and we need to extend it. 

What we can do is add another disk.

```sh
$ sudo qemu-img create -f qcow2 /data/libvirt/default/images/rocky9-test-data2.qcow2 1G -o preallocation=full
Formatting '/data/libvirt/default/images/rocky9-test-data2.qcow2', fmt=qcow2 cluster_size=65536 extended_l2=off preallocation=full compression_type=zlib size=1073741824 lazy_refcounts=off refcount_bits=16
$ sudo virsh attach-disk --domain rocky9-test /data/libvirt/default/images/rocky9-test-data2.qcow2 vdc --persistent --config
Disk attached successfully
```

Then use fdisk to create another LVM partition.

Afterwards, create a physical volume using pvcreate.

```sh
sudo pvcreate /dev/vdc1
```

Next, extend the volume group.

```sh
$ sudo vgs
  VG      #PV #LV #SN Attr   VSize   VFree
  data_vg   1   1   0 wz--n-  <5.00g 4.00m
  rl        1   2   0 wz--n- <39.00g    0 
sudo vgextend  data_vg /dev/vdc1
```

You can run `vgdisplay data_vg` to confirm the new size of the volume group.

Next, we need to extend the logical volume.

```sh
sudo lvextend --size +2G /dev/data_vg/data_lv
Size of logical volume data_vg/data_lv changed from 4.99 GiB (1278 extents) to 5.99 GiB (1534 extents).
Logical volume data_vg/data_lv successfully resized.
```

Alternatively, we can extend extents.

```sh
$ sudo lvextend --extents +100%FREE /dev/data_vg/data_lv /dev/vdc1 
  Size of logical volume data_vg/data_lv changed from <2.00 GiB (511 extents) to 3.99 GiB (1022 extents).
  Logical volume data_vg/data_lv successfully resized.
```


Next we need to grow the file system.

```sh
$ sudo xfs_growfs /dev/mapper/data_vg-data_lv 
meta-data=/dev/mapper/data_vg-data_lv isize=512    agcount=4, agsize=130816 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=523264, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 523264 to 1046528
```

If you want to start over, remove the volume group.

```sh
vgremove data_vg
```

You can then remove the physical volumes.

```sh
pvremove /dev/vdb1
pvremove /dev/vdc1
```

You can create multiple physical volumes at once; example: 

```sh
$ sudo pvcreate /dev/vdb1 /dev/vdc1
  Physical volume "/dev/vdb1" successfully created.
  Physical volume "/dev/vdc1" successfully created.
```

In case it's difficult to remember the order of the commands, see the manpage for lvm and scroll to the very bottom.

### Using Stratis

Stratis provides streamlined volume management of storage in RedHat Linux. Using Stratis, disk are added to a storage pool and logical volumes are extended automatically. 

To use stratis, first install stratis-cli and stratisd. 

```sh
$ sudo dnf install stratis-cli stratisd
```

Next, start and enable the stratisd service.

```sh
$ sudo systemctl enable stratisd
$ sudo systemctl start stratisd
$ sudo systemctl status stratisd
● stratisd.service - Stratis daemon
     Loaded: loaded (/usr/lib/systemd/system/stratisd.service; enabled; preset: en>
     Active: active (running) since Tue 2024-11-05 12:14:43 PST; 3s ago
       Docs: man:stratisd(8)
   Main PID: 2582 (stratisd)
      Tasks: 8 (limit: 23165)
     Memory: 2.3M
        CPU: 11ms
     CGroup: /system.slice/stratisd.service
             └─2582 /usr/libexec/stratisd --log-level debug

Nov 05 12:14:43 rocky9-test systemd[1]: Starting Stratis daemon...
Nov 05 12:14:43 rocky9-test stratisd[2582]: [2024-11-05T20:14:43Z INFO  stratisd::>
Nov 05 12:14:43 rocky9-test stratisd[2582]: [2024-11-05T20:14:43Z INFO  stratisd::>
Nov 05 12:14:43 rocky9-test stratisd[2582]: [2024-11-05T20:14:43Z INFO  stratisd::>
Nov 05 12:14:43 rocky9-test systemd[1]: Started Stratis daemon.
Nov 05 12:14:43 rocky9-test stratisd[2582]: [2024-11-05T20:14:43Z INFO  stratisd::>
```

If you look at the man page for stratis, the first thing it discusses is how to create a pool. To create a pool:

```sh
$ sudo stratis pool create data_pool /dev/vdb
```

If you get an error saying the block device appears to be owned, then you need to wipe the filesystem first.

```sh
$ sudo wipefs --all /dev/vdb
/dev/vdb: 2 bytes were erased at offset 0x000001fe (dos): 55 aa
/dev/vdb: calling ioctl to re-read partition table: Success
```

After creating the pool, we can extend it.

```sh
$  sudo stratis pool add-data data_pool /dev/vdc
```

Afterwards if we list the pool we should see the new size.

```sh
$ sudo stratis pool list
Name                  Total / Used / Free    Properties                                   UUID   Alerts
data_pool   4.00 GiB / 530 MiB / 3.48 GiB   ~Ca,~Cr, Op   bcbf4ea0-e7ac-4b55-b47a-c5c89edd084a  
```

Next, we can go ahead and create a filesystem on our pool.

```sh
$ sudo stratis filesystem create data_pool data_fs 
```

If we list the filesystem, we can see:

```sh
$ sudo stratis filesystem list
Pool        Filesystem   Total / Used / Free / Limit            Created             Device                           UUID                                
data_pool   data_fs      1 TiB / 546 MiB / 1023.47 GiB / None   Nov 05 2024 12:55   /dev/stratis/data_pool/data_fs   a07a51eb-f1ec-46dc-98cd-37633fd4ecfa
```

Afterwards, we just need to mount the filesystem.

```sh
$ sudo mount /dev/stratis/data_pool/data_fs /data/
```

To add the stratis filesystem to /etc/fstab, run `stratis filesystem list` to get the UUID. Then add the entry with the `xfs` filesystem type. Make sure you also specify that the stratisd needs to be started before the filesystem is mounted.

```sh
UUID=a07a51eb-f1ec-46dc-98cd-37633fd4ecfa /data	xfs	defaults,x-systemd.requires=stratisd.service 0 0
```

## NFS Service

To setup NFS, install the `nfs-utils` package on both Linux workstations and the NFS server.

```sh
sudo dnf install nfs-utils
```

On your NFS host, enable and start the NFS service.

```sh
sudo systemctl enable --now nfs-server
```

You must also start the rpcbind service, which NFS uses for port mapping.

```sh
sudo systemctl enable --now rpcbind
```

Afterwards add a line in `/etc/exports` to give access to a directory such as `/shared`.

```sh
$ sudo cat /etc/exports
/shared 192.168.1.0/24(rw)
```

If unsure of the syntax, see the manpage for exports.

To export this directory, use `exportfs`.

```sh
$ sudo exportfs -av
exporting 192.168.1.0/24:/shared
```

You might also want to set permissions on /shared.

You can also use the `-r` option to re-export the NFS directory.
```

On the client, we should enable and start the rpcbind service.

```sh
sudo systemctl enable --now rpcbind
```

You should also either disable the firewalld service or configure the firewall for NFS access. Below we disable firewalld.

```sh
$ sudo systemctl stop firewalld
$ sudo systemctl disable firewalld
Removed "/etc/systemd/system/multi-user.target.wants/firewalld.service".
Removed "/etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service".
```

Next, we can use `showmount` to see what directories are shared by the NFS server.

```sh
sudo showmount -e 192.168.1.40
Export list for 192.168.1.40:
/shared 192.168.1.0/24
```

Afterwards, we can mount the NFS directory.

```sh
$ sudo mkdir /shared
$ sudo mount -t nfs 192.168.1.40:/shared /shared
```

You can add the entry to /etc/fstab:

```sh
192.168.1.40:/shared   /shared nfs     defaults 0
```

## Boot Targets

Besides the commands `/sbin/shutdown`, you can use `systemctl` to reboot or shutdown your server.

To shutdown a server:

```sh
systemctl poweroff
```

To reboot a server:

```sh
systemctl reboot
```

The shutdown and reboot commands are actually symlinks to systemctl.

To get the current runlevel, use `systemctl`.

```sh
systemctl get-default
```

You can also get the run level by using `who`.

```sh
$ who -r
         run-level 3  2024-11-06 09:19
```

You can list the dependencies of each target using systemctl.

```sh
systemctl list-dependencies multi-user.target
```

You can see the different runlevels as softlinks in the filesystem.

```sh
$ ls -l /lib/systemd/system/runlevel*
lrwxrwxrwx. 1 root root 15 Sep  3 11:41 /lib/systemd/system/runlevel0.target -> poweroff.target
lrwxrwxrwx. 1 root root 13 Sep  3 11:41 /lib/systemd/system/runlevel1.target -> rescue.target
lrwxrwxrwx. 1 root root 17 Sep  3 11:41 /lib/systemd/system/runlevel2.target -> multi-user.target
lrwxrwxrwx. 1 root root 17 Sep  3 11:41 /lib/systemd/system/runlevel3.target -> multi-user.target
lrwxrwxrwx. 1 root root 17 Sep  3 11:41 /lib/systemd/system/runlevel4.target -> multi-user.target
lrwxrwxrwx. 1 root root 16 Sep  3 11:41 /lib/systemd/system/runlevel5.target -> graphical.target
lrwxrwxrwx. 1 root root 13 Sep  3 11:41 /lib/systemd/system/runlevel6.target -> reboot.target
```

A better way to get a list of targets is shown below:

```sh
sudo systemctl list-units --type target
```

Just as we can use systemctl get the current target, we can set it too.

```sh
systemctl get-default
systemctl set-default rescue
```

## Managing Firewalls

Firewalls in RedHat Linux are managed using the firewalld service and the firewall-cmd CLI. The CLI has many command-line switches and they are not easy to look up. This is true when you use the --help option or look up the options in the man page. So you do need to memorize how to use firewall-cmd.

To enable and start the firewall:

```sh
sudo systemctl enable --now firewalld
```

The first command you should know is to list the rules using  `list-all`.

```sh
$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp1s0
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

To get a list of all the services known to firewalld, use the --get-services option.

```sh
$ sudo firewall-cmd --get-services
RH-Satellite-6 RH-Satellite-6-capsule afp amanda-client amanda-k5-client amqp amqps apcupsd audit ausweisapp2 bacula bacula-client bareos-director bareos-filedaemon bareos-storage bb bgp bitcoin bitcoin-rpc bitcoin-testnet bitcoin-testnet-rpc bittorrent-lsd ceph ceph-exporter ceph-mon cfengine checkmk-agent cockpit collectd condor-collector cratedb ctdb dds dds-multicast dds-unicast dhcp dhcpv6 dhcpv6-client distcc dns dns-over-tls docker-registry docker-swarm dropbox-lansync elasticsearch etcd-client etcd-server finger foreman foreman-proxy freeipa-4 freeipa-ldap freeipa-ldaps freeipa-replication freeipa-trust ftp galera ganglia-client ganglia-master git gpsd grafana gre high-availability http http3 https ident imap imaps ipfs ipp ipp-client ipsec irc ircs iscsi-target isns jenkins kadmin kdeconnect kerberos kibana klogin kpasswd kprop kshell kube-api kube-apiserver kube-control-plane kube-control-plane-secure kube-controller-manager kube-controller-manager-secure kube-nodeport-services kube-scheduler kube-scheduler-secure kube-worker kubelet kubelet-readonly kubelet-worker ldap ldaps libvirt libvirt-tls lightning-network llmnr llmnr-client llmnr-tcp llmnr-udp managesieve matrix mdns memcache minidlna mongodb mosh mountd mqtt mqtt-tls ms-wbt mssql murmur mysql nbd nebula netbios-ns netdata-dashboard nfs nfs3 nmea-0183 nrpe ntp nut openvpn ovirt-imageio ovirt-storageconsole ovirt-vmconsole plex pmcd pmproxy pmwebapi pmwebapis pop3 pop3s postgresql privoxy prometheus prometheus-node-exporter proxy-dhcp ps2link ps3netsrv ptp pulseaudio puppetmaster quassel radius rdp redis redis-sentinel rpc-bind rquotad rsh rsyncd rtsp salt-master samba samba-client samba-dc sane sip sips slp smtp smtp-submission smtps snmp snmptls snmptls-trap snmptrap spideroak-lansync spotify-sync squid ssdp ssh steam-streaming svdrp svn syncthing syncthing-gui syncthing-relay synergy syslog syslog-tls telnet tentacle tftp tile38 tinc tor-socks transmission-client upnp-client vdsm vnc-server warpinator wbem-http wbem-https wireguard ws-discovery ws-discovery-client ws-discovery-tcp ws-discovery-udp wsman wsmans xdmcp xmpp-bosh xmpp-client xmpp-local xmpp-server zabbix-agent zabbix-server zerotier
```

The firewalld has multiple zones. To see all the zones:

```sh
$ sudo firewall-cmd --get-zones
block dmz drop external home internal nm-shared public trusted work
```

To see the current zone:

```sh
$ sudo firewall-cmd --get-active-zones
public
  interfaces: enp1s0
```

The default zone for RedHat Linux is `public`.

To change the zone:

```sh
$ sudo firewall-cmd --set-default=public
```

To see the rules for the `external` zone:

```sh
$ sudo firewall-cmd --zone=external --list-all
external
  target: default
  icmp-block-inversion: no
  interfaces: 
  sources: 
  services: ssh
  ports: 
  protocols: 
  forward: yes
  masquerade: yes
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 
```

To add a service to a zone:

```sh
$ sudo firewall-cmd --zone=external --add-service=http --permanent
success
```

Afterwards we need to reload the firewall rules.

```sh
$ sudo firewall-cmd --reload
```

To add custom services, copy one of the XML files in /usr/lib/firewalld/services to /etc/firewalld/services, edit the file, and restart the firewalld service. You might want to make sure it does not refer to any helpers.

You can also add custom ports directly to the firewall instead of defining services.

You can also add rich rules to block incoming traffic. It is best to look up examples in the firewalld.richlanguage man page. For example:

```sh
$ sudo firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.9" reject'
```

To block all ICMP incoming traffic:

```sh
$ sudo firewall-cmd --add-icmp-block-inversion
```

It is difficult to find this option from the manpage, but if you run `firewall-cmd --list-all` it will be listed for the current zone.

To block outgoing traffic to google.com, you could do:

```sh
firewall-cmd --direct --add-rule ipv4 filter OUTPUT 0 -d google.com -j DROP
success
```

## Containers

In RedHat, containers are managed using podman. It needs to be installed on the system.

```sh
dnf install podman
```

To run a container:

```sh
sudo podman run -d -p 8080:80 --name httpd docker.io/library/httpd
```

To manage containers through systemd, generate a unit file. In the previous step, you should give a proper name to the container because it will be used for the name of the service and CANNOT be changed later.

```sh
sudo podman generate systemd --new --files --name httpd
```

You can see an example in the man page for podman-generate-systemd.

Copy it to the systemd directory.

```sh
cp container-httpd.service /etc/systemd/system
```

Afterwards you should be able enable/start the service. You do not need to run systemctl daemon-reload. 

## References

- https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam?section=objectives
- https://access.redhat.com/solutions/7013886