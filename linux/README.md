# Linux Tips

## Introduction

This section covers a variety of topics related to Linux administration and was preparation for the RHCSA exam. 

## Pre-requisites

A VM running Rocky 9 was used as the training environment.

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

- Configure firewalls using firewall-cmd, which is available from the firewalld package. If you look at the man page for firewall-cmd, you can see some basic examples at the very bottom. 

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

- To remove an old kernel, you can use `dnf erase <package.of.kernel.to.remove>. Then use `dnf autoremove` to delete anything you don't need.

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

## Performance Tuning

- The `tuned` package has a service that can be used to automatically tune performance. This package has a CLI called `tuned-adm` which can be used to list available profiles, see the current profile, and change to a different profile. The profiles are stored in /usr/lib/tuned.

- From the cockpit GUI, you can change the profile by going to Overview | Configuration | Performance profile. 

- Use `renice` to change the nice value of proceses.

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

## References

- https://www.redhat.com/en/blog/linux-at-command

- https://www.sandervanvugt.com/red-hat-rhcsa-9-cert-guide-ex200/ 

- https://repost.aws/knowledge-center/create-lv-on-ebs-partition
