# RHCSA Study Guide

## Introduction

This section covers a variety of topics related to Linux administration and was used as preparation for the RHCSA exam. 

## Pre-requisites

A VM running Rocky 9 can be used as the training environment.

## Users

Use `chage` to change the password expirary per user. Although technically `passwd` can do all of the same things, it's preferable to just use `chage`. If you need to expire a user's password, run `chage -E 1 <user>`. By default, it is set to -1 so it will never expire.

Defaults password policies are stored in `/etc/login.defs`. For example, there are a few login-related variables related to passwords here. If the exam asks you to set default values for new users like password expirary and the first UUID, set it in `/etc/login.defs`.

Minimum password lengths are managed in `/etc/security/pwquality.conf` NOT /etc/login.defs.

If you need to require at least one digit, set dcredit to -1 in `/etc/security/pwquality.conf`. 

## History

To remove an item from user's history, run `history -d <history item>`. To remove all items, run `history -c`.

## Files and Processes

To see what files are consuming the most space in a directory such as /var, run: `du -k /var | sort -nr | more`.

It can be handy to find out the filesystem when running df. To do this, run `df -T`. 

The `free` command is not very human-friendly by default, but you can change the units easily buy using `m` or simply `-h` for human-readable.

The `lsof` command can be used to list open files (lsof stands for `list open files`). With no arguments, it's not very helpful. If you know that a user is logged into a system, you can find what files he has opened by running `lsof -u <user>`. Or what if you find a process from top and you want to find what files it has opened. For example, if top lists a process called `Isolated Web Co` with PID 16068, then run `lsof -p 16068` will give you a list of files that process has opeened. See https://www.redhat.com/en/blog/analyze-processes-lsof. 

The `tcpdump` command can be used to troubleshoot networking issues. For example, on host A, run `tcpdump -i <interface> host <source IP>`. Then from the source IP machine, run ping <ip.of.host.A>. You should see some output on host A indicating that the ping was successful. See https://hackertarget.com/tcpdump-examples/. Note that if you want to monitor port 22, you should login to the server from the console and not from an SSH session.

A command that shows what gateway traffic is flowing through is netstat. For example, `netstat -nrv`. If you run `netstat -t` you can see the list of outgoing TCP connections.

To find out detailed information on a file creation time, use `stat <file>`.

To see processes in a hierarchical chart, run `ps fax`.

You should know how to iterate through files from the `find` command. For example, `find . -type f -exec grep main {} \;` lists all the files in the current directory with the word `main`.

There are two options when using find with permissions. 

The use of `-` option means "at least this permission level is set, and any higher permissions.

The use of `/` means "any of the permissions listed are set.

Special permissions are configured using a fourth bit (leftmost):

- SUID = 4
- SGID = 2
- Sticky Bit = 1

For example:

```sh
# Finds files under / with SGID bit at least set to 000
find / -type f -perm -2000
```

## Devices

Devices are monitored by systemd-udevd. Run `udevadm monitor` and unplugin a USB device to see some output from this daemon.

## kernels

https://www.baeldung.com/linux/remove-old-kernels

## Kernel Modules

To list kernel modules, run `lsmod`.

To load a kernel module, run `modprobe`. 

To unload a kernel module, run `modprobe -r <module>`.

## Services

- To check all running services, run `systemctl --all`. 

- To reload configurations of services without restarting it, run `systemctl reload <service name>`. This is useful for services such as httpd or sshd for example. For example, by default sshd does not let the root user SSH into the OS. To enable this behavior, edit /etc/ssh/sshd_config and set the property `PermitRootLogin` to true. Then instead of restarting the service you could just reload the service.

- You can enable/disable services by using mask/unmask. In the case of mask, then the service will be started whether or not it is dependent on another service. If you unmask it, then the service will not be started as a dependency. 

## SSH

To make SSH more secure, it is good to set the `ClientAliveInterval` to a value such as 600 or 10 minutes to automatically logout idle SSH sessions. 

A hidden property is `AllowUsers`. This lets you restrict who can SSH to the server.

The SSH service listener port can be customized. SSH service configuration is in `/etc/ssh/sshd_config`. If you want to change the listener port, find the line that specifies a port, uncomment and change it to a different port (such as 2022), and run `semanage port -m -t ssh_port_t -p tcp 2022` (this is mentioned in /etc/ssh/sshd_config). If you want to add a port, then uncomment `PORT 22` and add another line with `PORT 2022` (for example). Then run `semanage port -a -t ssh_port_t -p tcp <port>`. Afterwards restart the SSH service. You may also need to update the firewall rules. If port 2022 is used, then run `firewall-cmd --add-port 2022 --permanent; firewall-cmd --reload`.

## Timezone

To list timezones run `timedatectl list-timezones`. To set the timezone, run `timedatectl set-timezone=<timezone>`. 

## NTP 

RedHat uses `chronyd` for NTP. 

Make sure timedatectl says that NTP synchronization is enabled.

```sh
$ timedatectl 
  Local time: Fri 2024-12-20 13:47:51 PST
  Universal time: Fri 2024-12-20 21:47:51 UTC
  RTC time: Fri 2024-12-20 21:47:51
  Time zone: America/Los_Angeles (PST, -0800)
  System clock synchronized: yes
  NTP service: active
  RTC in local TZ: no
```

If not, then set NTP to true and restart chrony.

```sh
timedatectl set-ntp true
systemctl restart chronyd
```

To configure chrony, edit `/etc/chrony.conf`. You can change the pool to pool.ntp.org. Afterwards, restart chronyd and run `chronyc sources`. 

To set up a server as an NTP server:

1. Disable the line in /etc/chrony.conf that says pool 2.rhel.pool.ntp.org.
2. Include the line allow 192.168.1.0/24 to allow access from all clients in the same network.
3. Include the line `local stratum 8`. 
4. Restart chrony: `systemctl restart chronyd`.
5. Enable ntp as a service in the firewall.
6. On the client, disable the line in /etc/chrony.conf that says `pool 2.rhel.pool.ntp.org`.
7. Add the line `server <server.name>`.
8. Restart chronyd

## Networking

The CLI tool for configuring networking in RedHat Linux is `nmcli`.

To get a list of network interfaces, run `nmcli connection`. A shorthand is `nmcli con` or `nmcli con show`.

In the exam, you may need to modify some parameters. To see all of the parameters for an IPv4 address, run:

```sh
nmcli con show enp1s0 | grep ipv4
```


The VM may be using DHCP by default, and most likely it needs to be configured with a static IP. First, make sure we disable autoconnect.

```sh
nmcli con mod enps1s0 connection.autoconnect no
```

Next, configure ipv4:

```sh
nmcli con mod enp1s0 ipv4.addresses 192.168.1.201/24 ipv4.gateway 192.168.1.1 ipv4.method manual ipv4.dns 8.8.8.8
```

To add multiple DNS servers, use quotes and spaces around each server IP.

```sh
nmcli con mod enp1s0 ipv4.dns "1.1.1.1 8.8.8.8"
```

Finally, bounce the interface.

```sh
nmcli con down enp1s0
nmcli con up enp1s0
```

You should validate the network settings by running `ip a`, `ip route` and checking the contents of /etc/resolv.conf.

It is preferrable to use `nmtui` during the exam.

## Packages

To find what package provides a binary, run `dnf provides **/<package name>`.

To see the list of configuration files for a package, use `rpm -qp <package name>`.

To see what package provides a file , use `rpm -qf <path.to.file>`. For example, 

```sh
$ which ssh
/usr/bin/ssh
$ sudo rpm -qf /usr/bin/ssh
openssh-clients-8.7p1-38.el9_4.4.x86_64
```

On the exam, you may need to create a local YUM repo fromm an ISO. Below are the steps:

- Create a directory called /iso
- Mount the AlmaLinux 9 ISO to /iso. For example: `mount /dev/sr1 /iso`.
- Install the createrepo package. It is in AppStream/c. For example: `dnf install createrepo_c-0.20.1-2.el9.x86_64.rpm createrepo_c-libs-0.20.1-2.el9.x86_64.rpm`
- Create a directory called /localrepo
- Create a directory called /localrepo/BaseOS
- Copy /iso/BaseOS/Packages to /localrepo/BaseOS/Packages
- Run `createrepo Packages -o`.
- Create a directory called /localrepo/AppStream
- Copy /iso/AppStream/Packages to /localrepo/AppStream/Packages
- Run `createrepo Packages -o .`
- Go to /etc/yum.repos.d
- Run `dnf config-manager --add-repo file:///localrepo/BaseOS` and `dnf config-manager --add-repo file:///localrepo/AppStream`
- Finally verify the repostories by running `dnf repolist -v`

> A 10GiB disk is barely enough for both repos!

To enable a yum repo, run `dnf config-manager --enable baseos`.

> You can use dnf config-manager --set-enabled or --enable to enable a repository. To disable a repository, you can use --set-disabled or --disable. If needed, it can be helpful on the exam to use the shorter syntax: --enable and --disable.

To remove an old kernel, you can use `dnf remove kernel-core-<version.of.kernel.to.remove>`. Then use `dnf autoremove` to delete anything you don't need. The `erase` option is deprecated. Since we only need to explictly remove one package, it is not very helpful to create a variable for the kernel version to remove.

To see what packages were installed, run `dnf history`. You can undo package installs this way by running `dnf history undo <id>.

To check if there are any package updates, run `dnf check-update`. This command is NOT easy to find in the man page, but if you want to search for it, search for `check`. 

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

The `egrep` command has a nifty feature that allows you to search for occurences of multiple strings in a file. For example:

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

To create a cron job, run `crontab -e`. For the syntax, see the content of /etc/crontab. 

```sh
$ sudo cat /etc/crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
```

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

Tips:

1. There's no need to memorize the crontab syntax. It is described in /etc/crontab.

## Logging

System logs are managed by the `systemd-journald` service.

By default, system journals are not persisted across reboots. To keep system journals after a reboot, do the following:

```sh
mkdir -p /var/log/journal
systemd-tmpfiles --create --prefix /var/log/journal
```

These steps are described in the manpage for systemd-journald.

You can use `rsyslog` to log messages to a specific log file. To do this, create a file under /etc/rsyslog.d with a syntax borrowed from /etc/rsyslog.conf. For example: 

```sh
# cat /etc/rsyslog.d/messages.conf
*.info                /var/log/message.info
```

will log info messages in /var/log/message.info. 

After writing the configuration file, restart rsyslogd.

To test, run `logger -p daemon.debug "Test"`.

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

Use `setfacl` to set access control lists for a file, and `getfacl` to get the ACL for a file. For example:

  ```sh
  $ setfacl -m u:taro:r anaconda-ks.cfg # Grants taro read access to this file
  $ setfacl -b anaconda-ks.cfg # Removes ACL from this file
  $ setfacl -mR u:john:rw /home/taro # Recorsively grants rw access to /home/taro to john
  ```

For example, one use case is to give unprivileged users read access to log files in /var/log. First, copy /var/log/secure to /tmp (just for testing). Next, run `setfacl -m u:taro:r /tmp/secure`. Now as user `taro` I should be able to read /`tmp/secure`.

To remove all extended ACL entries, use -b.

```sh
setfacl -b /var/log/secure
```

## SELinux

To change the SELinux policy, edit `/etc/selinux/config`.

To check the SELinux for a file, use `ls -lZ <file>`.

To check the SELinux for a directory, use `ls -DZ <directory>`.

You can check the SELinux label for a process by running `ps-axZ`. For example:

  ```sh
  $ ps -axZ |grep sshd
  system_u:system_r:sshd_t:s0-s0:c0.c1023 780 ?    Ss     0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
  system_u:system_r:sshd_t:s0-s0:c0.c1023 1321 ?   Ss     0:00 sshd: taro [priv]
  unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 1334 ? S   0:00 sshd: taro@pts/0
  unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 1394 pts/0 S+   0:00 grep --color=auto ss
  ```

You can check the SELinux label for a socket by running `netstat -tlpnZ`. For example:

  ```sh
  $ sudo netstat -tlpnZ | grep sshd
  tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      780/sshd: /usr/sbin  system_u:system_r:sshd_t:s0-s0:c0.c1023           
  tcp6       0      0 :::22                   :::*                    LISTEN      780/sshd: /usr/sbin  system_u:system_r:sshd_t:s0-s0:c0.c1023         
  ```

To see the list of SELinux labels that are on, run `getsebool -a`.

To set an SELinux label, run `setsebool`.

The `semanage` tool can also manage labels.

For example, SELinux does not allow HTTP services to connect to FTP servers by default.

  ```sh
  $ getsebool -a | grep httpd_can_connect_ftp
  httpd_can_connect_ftp --> off
  $ setsebool httpd_can_connect_ftp 1
  $ sudo getsebool httpd_can_connect_ftp
  httpd_can_connect_ftp --> on
  ```

You may want to run setsetbool with the `-P` option so that the setting is fixed across reboots.

Use `semanage export` to see the current settings.

## How to Break into RedHat Linux

Reboot the system. If this is a KVM, run `virsh restart <domain>` When you see the list of kernels, select one and type `e` for edit. Then go to the end of the kernel arguments and add `rd.break`. If there is any mention of redirecting output to the console, remove it.

If `rd.break` does not work, then you can use `init=/bin/bash`. This may be needed for RHEL 9.0.

Adding `emergency` to grub mounts the root partition automatically.

## Managing Grub

The `grubby` CLI tool is used to manage grub options.

The man page for grubby does not have any examples and is not easy to read in a pinch. It is best to memorize the commands most often used. However, the general idea is to specify `--args` and `--update-kernel`.

The first of these is used to list the arguments for all the kernels.:

```sh
grubby --info=ALL`
```

To add arguments, use the format:

```sh 
grubby --args=<arguments> --update-kernel=ALL
```

To remove arguments:

```sh
grubby --remove-args --update-kernel=ALL
```

To see the current kernel, run:

```sh
grubby --default-kernel
```

## Managing Disks

### Partition Tables

For any disk to be usable, it must have a partition table. There are two main types that you can work with on Linux: MBR and GPT. 

The MBR partition type is a legacy partiton type. Partition sizes are limited to 2TB and you can only create up to 4 partitions. You can also create extended partitions for a total of 15 partitions. 

The GPT partition type solves many of the limitations of MBR. Unless you are required to use MBR, use GPT. 

Concerning tools, `fdisk` is the legacy tool and `gdisk` is the newer tool. When starting `fisk`, it will assume you want to use MBR. When using `gdisk`, it will assume you want to use GPT. However, in practice `fdisk` is easier to use.

### Using gdisk to create primary partitions

The first step is to find the disk you want to modify. You can use `lsblk` to do this. Afterwards, you can create primary partitions by just typing `n`.

```sh
[root@rocky-server ~]# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0   20G  0 disk 
├─sda1                      8:1    0    1G  0 part /boot
└─sda2                      8:2    0   19G  0 part 
  ├─rl_rocky--server-root 253:0    0   17G  0 lvm  /
  └─rl_rocky--server-swap 253:1    0    2G  0 lvm  [SWAP]
sr0                        11:0    1 1024M  0 rom  
sr1                        11:1    1 10.2G  0 rom  /run/media/root/Rocky-9-4-x86_64-dvd
vda                       252:0    0   20G  0 disk 
[root@rocky-server ~]# gdisk /dev/vda
GPT fdisk (gdisk) version 1.0.7

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries in memory.

Command (? for help): n
Partition number (1-128, default 1): 
First sector (34-41949918, default = 2048) or {+-}size{KMGTP}: 
Last sector (2048-41949918, default = 41949918) or {+-}size{KMGTP}: +1G
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 
Changed type of partition to 'Linux filesystem'

Command (? for help): p
Disk /dev/vda: 41949952 sectors, 20.0 GiB
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): EFF1C91F-EB00-4E51-8CA3-72D43CC905EB
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 41949918
Partitions will be aligned on 2048-sector boundaries
Total free space is 39852733 sectors (19.0 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         2099199   1024.0 MiB  8300  Linux filesystem

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): Y
OK; writing new GUID partition table (GPT) to /dev/vda.
The operation has completed successfully.
```

### Using fdisk to create primary partitions

To do the same with fdisk:

```sh
[rocky@rocky-server ~]$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0   20G  0 disk 
├─sda1                      8:1    0    1G  0 part /boot
└─sda2                      8:2    0   19G  0 part 
  ├─rl_rocky--server-root 253:0    0   17G  0 lvm  /
  └─rl_rocky--server-swap 253:1    0    2G  0 lvm  [SWAP]
sr0                        11:0    1 1024M  0 rom  
sr1                        11:1    1 10.2G  0 rom  /run/media/root/Rocky-9-4-x86_64-dvd
vda                       252:0    0   20G  0 disk 
[rocky@rocky-server ~]$ fdisk /dev/vda

Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Command (m for help): m

Help:

  GPT
   M   enter protective/hybrid MBR

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table


Command (m for help): g
Created a new GPT disklabel (GUID: 930315E4-05E6-0147-891C-D09C4F7B969F).

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

[rocky@rocky-server ~]$ sudo fdisk /dev/vda

Welcome to fdisk (util-linux 2.37.4).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): n
Partition number (1-128, default 1): 
First sector (2048-41949918, default 2048): +1G
Value out of range.
First sector (2048-41949918, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-41949918, default 41949918): +1G

Created a new partition 1 of type 'Linux filesystem' and of size 1 GiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

### Create partitions

Afterwards you need to create a filesystem. Partitions need filesystems or they aren't usable to Linux.

How do you know if a partition has a fileystem or not? Run `lsblk -lf`. Below, you can see that vda1, the GPT partiton we just created, has no partitions.

```sh
[root@rocky-server rocky]# lsblk -lf
NAME FSTYPE  FSVER    LABEL                UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                                              
sda1 xfs                                   6002c4fd-7572-4a1f-b1ea-fb344afd3b2a    656.9M    32% /boot
sda2 LVM2_me LVM2 001                      P8yXn2-MbFN-Lt0L-lDHN-RTHA-i0zW-pCEWBL                
sr0                                                                                              
sr1  iso9660 Joliet E Rocky-9-4-x86_64-dvd 2024-05-05-01-12-25-00                       0   100% /run/media/root/Rocky-9-4-x86_64-dvd
vda                                                                                              
vda1                                                                                             
rl_rocky--server-root
     xfs                                   8e4b7245-2259-4fa9-bc85-39436a8f4d37     11.7G    31% /
rl_rocky--server-swap
     swap    1                             2a2230cb-b0a6-43a0-bc8b-77c229ab2398                  [SWAP]
```

After we run `mkfs.ext4` and run `lsblk -lf` again, we should see the filesystem type. In this case, it's ext4.

```sh
[root@rocky-server rocky]# mkfs.ext4 /dev/vda1
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done                            
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 089b3290-053a-4ede-9ffa-f915b130d1fd
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

[root@rocky-server rocky]# lsblk -lf
NAME FSTYPE  FSVER    LABEL                UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                                              
sda1 xfs                                   6002c4fd-7572-4a1f-b1ea-fb344afd3b2a    656.9M    32% /boot
sda2 LVM2_me LVM2 001                      P8yXn2-MbFN-Lt0L-lDHN-RTHA-i0zW-pCEWBL                
sr0                                                                                              
sr1  iso9660 Joliet E Rocky-9-4-x86_64-dvd 2024-05-05-01-12-25-00                       0   100% /run/media/root/Rocky-9-4-x86_64-dvd
vda                                                                                              
vda1 ext4    1.0                           089b3290-053a-4ede-9ffa-f915b130d1fd                  
rl_rocky--server-root
     xfs                                   8e4b7245-2259-4fa9-bc85-39436a8f4d37     11.7G    31% /
rl_rocky--server-swap
     swap    1                             2a2230cb-b0a6-43a0-bc8b-77c229ab2398                  [SWAP]
```

If we want an XFS filesystem, then we can use `mkfs.xfs`. 

```sh
[root@rocky-server rocky]# mkfs.xfs /dev/vda1
meta-data=/dev/vda1              isize=512    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
[root@rocky-server rocky]# lsblk -lf
NAME FSTYPE  FSVER    LABEL                UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                                              
sda1 xfs                                   6002c4fd-7572-4a1f-b1ea-fb344afd3b2a    656.9M    32% /boot
sda2 LVM2_me LVM2 001                      P8yXn2-MbFN-Lt0L-lDHN-RTHA-i0zW-pCEWBL                
sr0                                                                                              
sr1  iso9660 Joliet E Rocky-9-4-x86_64-dvd 2024-05-05-01-12-25-00                       0   100% /run/media/root/Rocky-9-4-x86_64-dvd
vda                                                                                              
vda1 xfs                                   3fca7653-5a81-440e-b36a-66c179286c7e                  
rl_rocky--server-root
     xfs                                   8e4b7245-2259-4fa9-bc85-39436a8f4d37     11.7G    31% /
rl_rocky--server-swap
     swap    1                             2a2230cb-b0a6-43a0-bc8b-77c229ab2398                  [SWAP]
```

### Creating physical volumes with pvcreate

To use a disk with LVM, you must have a physical disk. To create a physical disk, use `pvcreate`. You can run `pvs` to verify the existing physical volumes. Use `pvs` to verify the state of physical volumes.

```sh
[root@rocky-server rocky]# lsblk -lf
NAME FSTYPE  FSVER    LABEL                UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                                              
sda1 xfs                                   6002c4fd-7572-4a1f-b1ea-fb344afd3b2a    656.9M    32% /boot
sda2 LVM2_me LVM2 001                      P8yXn2-MbFN-Lt0L-lDHN-RTHA-i0zW-pCEWBL                
sr0                                                                                              
sr1  iso9660 Joliet E Rocky-9-4-x86_64-dvd 2024-05-05-01-12-25-00                       0   100% /run/media/root/Rocky-9-4-x86_64-dvd
vda                                                                                              
vda1                                                                                             
vda2                                                                                             
rl_rocky--server-root
     xfs                                   8e4b7245-2259-4fa9-bc85-39436a8f4d37     11.7G    31% /
rl_rocky--server-swap
     swap    1                             2a2230cb-b0a6-43a0-bc8b-77c229ab2398                  [SWAP]
[root@rocky-server rocky]# pvs
  PV         VG              Fmt  Attr PSize   PFree
  /dev/sda2  rl_rocky-server lvm2 a--  <19.00g    0 
[root@rocky-server rocky]# pvcreate /dev/vda2
  Physical volume "/dev/vda2" successfully created.
[root@rocky-server rocky]# pvs
  PV         VG              Fmt  Attr PSize   PFree
  /dev/sda2  rl_rocky-server lvm2 a--  <19.00g    0 
  /dev/vda2                  lvm2 ---    1.00g 1.00g
```

### Using Volume groups

Next, we need to associate physical volumes with a volume group. We can either use an existing volume group or create a new one. If we use add a physical volume to an existing volume group, then we can extend a filesystem. If we create a new volume group, then we can dedicate it to a new filesystem. The tool used to manage volume groups include `vgcreate`, `vgs` and `vgdisplay`.

In example below, we create a new volume group.

```sh
root@rocky-server rocky]# vgcreate 
  No command with matching syntax recognised.  Run 'vgcreate --help' for more information.
  Correct command syntax is:
  vgcreate VG_new PV ...

[root@rocky-server rocky]# pvs
  PV         VG              Fmt  Attr PSize   PFree
  /dev/sda2  rl_rocky-server lvm2 a--  <19.00g    0 
  /dev/vda2                  lvm2 ---    1.00g 1.00g
[root@rocky-server rocky]# vgcreate data_vg /dev/vda2
  Volume group "data_vg" successfully created
[root@rocky-server rocky]# pvs
  PV         VG              Fmt  Attr PSize    PFree   
  /dev/sda2  rl_rocky-server lvm2 a--   <19.00g       0 
  /dev/vda2  data_vg         lvm2 a--  1020.00m 1020.00m
[root@rocky-server rocky]# vgs
  VG              #PV #LV #SN Attr   VSize    VFree   
  data_vg           1   0   0 wz--n- 1020.00m 1020.00m
  rl_rocky-server   1   2   0 wz--n-  <19.00g      
```

The `vgcreate` tool has a few command line options. For example, we can specify the extents size using the -s option.

```sh
vgcreate -s 8 data_vg /dev/vdb1 
```

### Using logical volumes

Next we can create logical volumes. One thing to remember, logical volumes are ALWAYS created out of volume groups. If you don't provide the name of the logical volume, lvcreate will create one for you.

```sh
[root@rocky-server rocky]# vgs
  VG              #PV #LV #SN Attr   VSize    VFree   
  data_vg           1   0   0 wz--n- 1020.00m 1020.00m
  rl_rocky-server   1   2   0 wz--n-  <19.00g       0 
[root@rocky-server rocky]# lvcreate -L 500M --name data_lv data_vg 
  Logical volume "data_lv" created.
[root@rocky-server rocky]# lvs
  LV      VG              Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  data_lv data_vg         -wi-a----- 500.00m                                                    
  root    rl_rocky-server -wi-ao---- <17.00g                                                    
  swap    rl_rocky-server -wi-ao----   2.00g                                                    
```

To create the logical volume with the entire disk space available, use `-l`.

```sh
lvcreate -l +100%FREE --name data_lv data_vg
```

Finally, we must remember to create a filesystem on the logical volume.

```sh
mkfs.xfs /dev/data_vg/data_lv
```

Afterwards we need to mount it. The path to the logical volume is the one we used when creating the file system.

```sh
sudo mount /dev/data_vg/data_lv /data
```

### Extending an LVM volume

Let's say vdb ran out of disk space and we need to extend it. 

First we use fdisk to create another Linux partition.

Afterwards, create a physical volume using pvcreate.

```sh
sudo pvcreate /dev/vdc1
```

Next, we need to extend the volume group to include the PV we just created.

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

Alternatively, we can extend extents. Below we extend it 100% so it fills all the available space in the volume group.

```sh
$ sudo lvextend --extents +100%FREE /dev/data_vg/data_lv /dev/vdc1 
  Size of logical volume data_vg/data_lv changed from <2.00 GiB (511 extents) to 3.99 GiB (1022 extents).
  Logical volume data_vg/data_lv successfully resized.
```

At this point, lvdisplay should show the expanded storage but `df -Th` will not. What we need to do next is run `xfs_growfs` on the root partition. If this was an ext3 or ext4 partition, use `resize2fs` instead.

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

How are the two tools different? With XFS, filesystems can only be expanded; with ext3 or ext4, filesystems can grow or shrink. That's why `xfs_growfs` will only grow a filesystem while `resize2fs` can either shrink or grow a filesystem.

### Renaming LVM

 You can skip the name of the logical volume if you want, but it's a good practice to provide a name or lvcreate will assign one for you. If you forgot and don't like the name of the logical volume, use lvrename.

```sh
[root@rocky-server rocky]# lvs
  LV      VG              Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  data_lv data_vg         -wi-a----- 500.00m                                                    
  root    rl_rocky-server -wi-ao---- <17.00g                                                    
  swap    rl_rocky-server -wi-ao----   2.00g                                                    
[root@rocky-server rocky]# lvrename data_vg data_lv new_data_lv
  Renamed "data_lv" to "new_data_lv" in volume group "data_vg"
[root@rocky-server rocky]# lvs
  LV          VG              Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  new_data_lv data_vg         -wi-a----- 500.00m                                                    
  root        rl_rocky-server -wi-ao---- <17.00g                                                    
  swap        rl_rocky-server -wi-ao----   2.00g                                              
```

### Removing LV

You can remove a logical volume to create a new filesystem on it. First you should deactivate the volume.

```sh
lvchange -an /dev/data_vg/data_lv
```

Next, use `lvremove` to remove the logical volume.

```sh
lvremove /dev/data_vg/data_lv
```

It might be easier just to run lvremove with the `-f` option so that lvremove will deactivate the logical volume automatically.

```sh
lvremove -f /dev/data_vg/data_lv
```

Next remove the physical volume from the volume group.

```sh
vgreduce data_vg /dev/vdb2
```

### Creating RAID with LVM

LVM can also create RAID devices. Below is an example where we create a RAID 1 (mirroring) device from 2 virtual disks:

```sh
[root@rocky-server ~]# lvcreate -m 1 --type raid1 --name home_raid   -l +100%FREE home_vg
  Logical volume "home_raid" created.
[root@rocky-server ~]# lvs
  LV        VG              Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home_raid home_vg         rwi-a-r--- 4.99g                                    6.25            
  root      rl_rocky-server -wi-ao---- 6.99g                                                    
  swap      rl_rocky-server -wi-ao---- 2.00g     
[root@rocky-server ~]# lvdisplay /dev/home_vg/home_raid 
  --- Logical volume ---
  LV Path                /dev/home_vg/home_raid
  LV Name                home_raid
  VG Name                home_vg
  LV UUID                3q9h5d-NckU-aQmu-Cead-ELfG-2c4O-I5jZCP
  LV Write Access        read/write
  LV Creation host, time rocky-server, 2024-11-24 15:21:01 -0800
  LV Status              available
  # open                 1
  LV Size                4.99 GiB
  Current LE             1278
  Mirrored volumes       2
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:6
```

### Labeling partitions

Partition labels can be used to identify partitions instead of UUIDs. You can use these labels in /etc/fstab.  There are a few command-line tools to set the label. The `e2label` command can be used to set the label for ext3 and ext4 partitions while `fatlabel` can be used to set the label for MS-DOS partitions. These are mentioned in the man page for fstab. For XFS filesystems, use `xfs_admin`.

### Changing the UUID

Use `uuidgen` to generate a UUID, then use `xfs_admin` to set it on a file system.

### Using Stratis

Stratis provides streamlined volume management of storage in RedHat Linux. Using Stratis, disk are added to a storage pool and logical volumes are extended automatically. 

The concepts to know about Stratis are pools and filesystems. 

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

After creating the pool, we can extend it (if we have another device).

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

To add the stratis filesystem to /etc/fstab, run `stratis filesystem list` to get the UUID. Then add the entry with the `xfs` filesystem type. Make sure you also specify that the stratisd needs to be started before the filesystem is mounted. See the man page for systemd.mount.

```sh
UUID=a07a51eb-f1ec-46dc-98cd-37633fd4ecfa /data	xfs	defaults,x-systemd.requires=stratisd.service 0 0
```

### Creating swap partitions

First, check the current swap space by running `free -m`.

Use fdisk to create a swap partition. The partition type should be set to `swap`.

Afterwards, use `mkswap` to partition the swap space. 

Enable the swap space by running `swapon`. Run `free -m` again to verify the swap space. 

To make the change permanent, add an entry in /etc/fstab like:

```sh
UUID=543debbb-cfe0-48c0-b6a4-8d389df760d0 none	swap defaults 0 0
```

Remember to run `systemctl daemon-reload` after making any changes to /etc/fstab.

### Creating swap files

First, create the swap file as mentioned in the man page for `mkswap`. For example, 

```sh
dd if=/dev/zero of=/swapfile bs=GiB count=2
```

This will create a 2GiB swap file.

Next, we need to enable the swap file by using mkswap.

```sh
sudo mkswap /swapfile 
mkswap: /swapfile: insecure permissions 0644, fix with: chmod 0600 /swapfile
Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
no label, UUID=9161e3ef-998f-4c3a-a6fd-b94b7fdc224b
```

Afterwards, you can use swapon to enable the swap.

```sh
sudo swapon /swapfile
```

Use `free -m` to verify before and after swap space.


### Configuring autofs 

The autofs service mounts filesystems on demand. This can be useful if you are mounting a filesytem through NFS and don't want a persistent connection.

First, you need to have an NFS server running and exporting a directory over the network.

On the client, install the autofs package.

Next, edit /etc/auto.master. It has the following format:

```sh
/data  /etc/auto.nfsdata
```

Where auto.users is a file we need to create.

Next, we create /etc/auto.nfsdata with the following content:

```sh
files -rw localhost:/nfsdata
```

Restart autofs service. Then type `cd /data/files/ to access the NFS mount.

The autofs service can also handle wildcards in case we don't want to specify multiple directories. For example, let's say linda and anna have their home directories set to /home/users/linda and /home/users/anna. We want to make sure that while these users access their home directory, autofs is used to mount the NFS shares /users/linda and /users/anna from the same server.

```sh
$cat /etc/exports
/users  192.168.1.0/24(rw,no_root_squash)
$ exportfs -rv
exporting 192.168.1.0/24:/users
```

Next, we create /etc/auto.master. This is taken from the client-side point of view, so that when the client cds to /home/users, then consult the file /etc/users.misc.

```sh
/home/users /etc/users.msic
```

The content of /etc/users.misc should be:

```sh
* -rw localhost:/users/&
```

After restarting autofs, then users should be able to cd to /home/users/linda and /home/users/anna.

For automounting local filesystems, there is a better way using `systemd`. In /etc/fstab, configure the partition with `systemd.automount`. For example:

```sh
UUID="2cb71861-c294-4ed7-8489-cfa7a97c8db7"	/backup	xfs	noauto,x-systemd.automount 0 2
```

The /backup directory would have to be created beforehand. Afterwards, you need to restart one or both services:

```sh
systemctl restart local-fs.target
systemctl restart remote-fs.target
```

### Tips

- To get the UUID of a partition, use `blkid`.
- To mount an ISO automatically, you can use the `auto` file system type in /etc/fstab.
- You can run `mount -a` to mount all partitions (except swap) that aren't mounted currently.
- The reason why `systemd daemon-reload` needs to be run after changing /etc/fstab is because in RedHat Linux, /etc/fstab is used to generate services in /run/systemd/generator that are used to mount filesystems.
- You can use `findmnt -s` to validate the contents of /etc/fstab. Check that the columns have the correct information.

## Web Servers

What you have to remember about configuring web servers for the exam is that they may want you to configure the system so that a web site can be accessed from a non-standard port AND with SELinux enabled.

To do this:

- Make sure httpd is running and /etc/httpd/httpd.conf has the port configured. Check to see if the website is accessible or not by using curl.
- If it's not accesible, try disabling SELinux by running `setenforce 0` and restart httpd.
- You want to look up the manage page for semanage, specifically, semanage-port. It will have an example of what command to run to open up a port. For example, `semanage port -a -t http_port_t -p tcp 81`. 
- Run `setenforce 1`, restart httpd, and check that the website is accesible.
- For troubleshooting, run `semanage port -l | grep http`. 

## NFS Service

For the RHCSA exam, NFS is often combined with autofs so both will be discussed below.

On the NFS server, install the `nfs-utils` package. 

```sh
sudo dnf install nfs-utils
```

Start the nfs-server service.


```sh
sudo systemctl enable --now nfs-server
```

Afterwards add a line in `/etc/exports` to give other servers access to a directory, such as `/shared`. 

One example is shown below:

```sh
/nfsdata *(rw,no_root_squash)
```

Below is another example where we give access to the /shared directory to servers in a specific subnet.

```sh
/shared 192.168.1.0/24(rw,no_root_squash)
```

If unsure of the syntax, see the manpage for exports.

If you change the contents of /etc/exports, export the directories again by using `exportfs`.

```sh
$ sudo exportfs -rv
exporting *:/nfsdata
```

Configure firewalld to open the services.

```sh
firewall-cmd --add-service={nfs,rpc-bind,mountd} --permanent 
firewall-cmd --reload
```

You have to memorize the list of services. The man page for nfs has some hints about what services to enable, but it is not clear.

Hard to memorize? The systemctl has a way to show dependencies of the nfs-server service.

```sh
[root@atlantic nfs-utils]# systemctl list-dependencies nfs-server
nfs-server.service
● ├─-.mount
○ ├─auth-rpcgss-module.service
● ├─nfs-idmapd.service
● ├─nfs-mountd.service
● ├─nfsdcld.service
● ├─proc-fs-nfsd.mount
● ├─rpc-statd-notify.service
● ├─rpc-statd.service
● ├─rpcbind.socket
● ├─system.slice
● ├─network-online.target
● │ └─NetworkManager-wait-online.service
● └─network.target
```

Another thing you can try is look at the man page for nfs-server and search for `service`. It will mention rpcbind and mountd. 

There are 3 things you need to do on the client to mount NFS shares.

- Install nfs-utils
- Run showmount to list the NFS mounts
- Mount the filesystems

From the client, install `nfs-utils`.

Next, use `showmount` to see what directories are shared by the NFS server.

```sh
sudo showmount -e 192.168.1.30
Export list for 192.168.1.30:
/nfsdata *
```

Afterwards, we can mount the NFS directory.

```sh
$ sudo mkdir /nfsdata
$ sudo mount -t nfs 192.168.1.30:/nfsdata /nfsdata
```

We can add an entry to /etc/fstab:

```sh
192.168.1.30:/nfsdata   /nfsdata nfs     defaults 0 2
```

NFS is often used in conjunction with automount. If you use automount, you do not need to create an entry in /etc/fstab.

On the NFS client, install autofs and start/enable the autofs service.

Next, configure /etc/auto.master. For example:

```sh
/nfsdsata	/etc/nfsdata.misc
```

Next, create nfsdata.misc:

```sh
files	-rw	nfsserver:/nfsdata
```

Restart the autofs service.

We should now be able to navigate to /nfsdata/files.

Another scenario is to configure autofs so that the mount point does not require that a user cd to a subdirectory. The syntax is:

```sh 
/- /etc/nfsdata.misc
```

and in nfsdata.misc:

```sh
nfsdata -rw nfsserver:/nfsdata
```

It can be difficult to troubleshoot autofs issues. To start autofs in debug mode, modify /etc/sysconfig/autofs and set OPTIONS="--debug". Restart autofs and look at journald logs while attempting to mount the remote directory. 

For example, autofs can fail because the hostname in used in nfsdata.misc doesn't resolve to the correct server in /etc/hosts.

```sh
Dec 14 16:29:12 pacific automount[38410]: mount(nfs): root=/nfs name=files what=atlantics:/shared, fstype=nfs, options=rw
Dec 14 16:29:12 pacific automount[38410]: mount(nfs): nfs options="rw", nobind=0, nosymlink=0, ro=0
Dec 14 16:29:12 pacific automount[38410]: add_host_addrs: hostname lookup for atlantics failed: Name or service not known
Dec 14 16:29:12 pacific automount[38410]: mount(nfs): no hosts available
Dec 14 16:29:12 pacific automount[38410]: dev_ioctl_send_fail: token = 32
Dec 14 16:29:12 pacific automount[38410]: failed to mount /nfs/files
Dec 14 16:29:12 pacific automount[38410]: handle_packet: type = 3
Dec 14 16:29:12 pacific automount[38410]: handle_packet_missing_indirect: token 33, name files, request pid 37942
Dec 14 16:29:12 pacific automount[38410]: dev_ioctl_send_fail: token = 33
Dec 14 16:29:12 pacific automount[38410]: handle_packet: type = 3
Dec 14 16:29:12 pacific automount[38410]: handle_packet_missing_indirect: token 34, name files, request pid 37942
Dec 14 16:29:12 pacific automount[38410]: dev_ioctl_send_fail: token = 34
Dec 14 16:29:50 pacific systemd[1]: Stopping Automounts filesystems on demand...
```

This particular problem was fixed by setting the correct IP in /etc/hosts.

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

To get the current target, use `systemctl`.

```sh
systemctl get-default
```

You can get the run level by using `who`.

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

To list all the types of units that systemd manages, you can run:

```sh
ls -1 /lib/systemd/system | awk -F"." '{print $NF}' | sort | uniq
automount
d
mount
path
service
slice
socket
target
timer
wants
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

It can be eaiser just to go to /usr/lib/firewalld/services to see the list.

The `firewalld` service has multiple zones. To see all the zones:

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

In RedHat, containers are managed using podman. The podman packages needs to be installed on the system.

```sh
dnf install podman
```

On the RHCSA exam, containers are used to run services that would normally be run on the server itself. However, this requires additional configuration.

To run a container:

```sh
sudo podman run -d -p 8080:80 --name httpd docker.io/library/httpd
```

There are times when you need to pass in environment variables in order to run a container. In this case, we can inspect the image using skopeo.

```sh
 skopeo inspect docker://registry.access.redhat.com/rhscl/mariadb-101-rhel7 | less
```

A few lines down we can see usage information:

```sh
"usage": "docker run -d -e MYSQL_USER=user -e MYSQL_PASSWORD=pass -e MYSQL_DATABASE=db -p 3306:3306 rhscl/mariadb-101-rhel7",
```

What if we want to run nginx instead of Apache? We can use the nginx:alpine image:

```sh
podman run --rm -p 8080:80 nginx:alpine
```

If your run a container as a root user, then UIDs are mapped to the container without issues. 

If you want to run rootless containers then you need to do some more work. Below are the steps, followed by just the description:

```sh
# Run the container with no options. This will result in an error message saying credentials are missing.
podman run --name mydb  --rm  -p 3309:3309 mariadb:lts-ubi9
2024-12-20 01:47:23+00:00 [Note] [Entrypoint]: Entrypoint script for MariaDB Server 11.4.4 started.
2024-12-20 01:47:23+00:00 [ERROR] [Entrypoint]: Database is uninitialized and password option is not specified
	You need to specify one of MARIADB_ROOT_PASSWORD, MARIADB_ROOT_PASSWORD_HASH, MARIADB_ALLOW_EMPTY_ROOT_PASSWORD and MARIADB_RANDOM_ROOT_PASSWORD

# Run the container with a password
podman run --name mydb  -e MARIADB_ROOT_PASSWORD=pasword --rm -p 3309:3309 mariadb:lts-ubi9

# Find the UID/GID of the user running mariadb
[rocky@atlantic ~]$ podman exec mydb cat /etc/passwd |grep mysql
mysql:x:999:999::/var/lib/mysql:/bin/bash

# Create a local directory called mydb
mkdir mydb

# Run podman unshare to map the UID and GID
podman unshare chown 999:999 mydb

# Stop the container
podman stop <container id>

# Run the container again with a bindmount
podman run --name mydb -v /home/rocky/mydb:/var/lib/mysql:Z -e MARIADB_ROOT_PASSWORD=pasword --rm -p 3309:3309 mariadb:lts-ubi9
```

First, get the UID mapping, use `podman unshare cat /proc/self/uid_map`. You may be able to find the UID of the user that runs the main application by running `podman inspect imagename`. Otherwise, use `podman exec <container name> cat /etc/passwd`. Afterwards, use `podman unshare chown nn:nn directoryname` to set the container UID as the owner of the directory on the host. Make sure the directory is in the user's home directory. Verify the mapped user is owned on the host by running `ls -ld <path>`.

For nginx, we could do the following:

```sh
# Run the latest nginx image, NOT alpine
podman run --rm --name nginx docker.io/library/nginx:latest

# Get into the container
podman exec -ti nginx sh

# Find the UID/GIDs we need
cat /etc/passwd | grep nginx
nginx:x:101:101:nginx user:/nonexistent:/bin/false

# Find out where the files are served
find / -name "*.html"
find: '/proc/tty/driver': Permission denied
find: '/proc/24/map_files': Permission denied
find: '/proc/25/map_files': Permission denied
/usr/share/nginx/html/50x.html
/usr/share/nginx/html/index.html

# Stop the container
podman stop nginx

# Make a local directory
mkdir html

# Create an HTML file in it
touch html/index.html

# Map the UID/GID with podman unshare
podman unshare chown -R 101:101 html

# Finally run the container
podman run --rm --name nginx -p 8080:80 -v /home/rocky/html:/usr/share/nginx/html:Z docker.io/library/nginx:latest 
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

## Troubleshooting

To boot from the rescue disk, hit ESC after POST and select the ISO. Next, choose Troubleshooting | Rescue | 1) Continue. At the shell, type `chroot /mnt/sysroot`. Relabeling will happen automatically. 

If the system does not boot, it might be because grub is corrupted. After booting into the Rescue Disk, regenerate grubby running `grub2-install <device.path>`. For example, `grub2-install /dev/sda`. This should recreate /boot/grub2. 

There are some CLI tools written by Karel Zak in the util-linux github project that can be useful for troubleshooting disks. These include `findmnt` and `findfs`. In particular, `findmnt -s` can be used to parse /etc/fstab and can help spot formatting issues.

## References

- https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam?section=objectives
- https://learn.redhat.com/t5/General/How-do-you-remember-commands/td-p/15791
- https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/configuring_and_using_network_file_services/deploying-an-nfs-server_configuring-and-using-network-file-services#configuring-an-nfsv3-server-with-optional-nfsv4-support_deploying-an-nfs-server 