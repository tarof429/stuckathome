# Kernel Crash Debuggging 

## Introduction

Recently I came across an interesting article on debugging kernel crashes. I decided to see if I could replicate this using a KVM running Ubuntu.

## Setup

1. Create an Ubuntu 22 VM by going to ../kvm/files/ubuntu and running:

    ```
    sh ./create_ubuntu_vm.sh myvm 40G
    ```

2. Confirm that kdump is configured into the kernel (it is):

    ```
    root@ubuntu:~# grep -Rin "CONFIG_CRASH_DUMP" /boot/config-5.15.0-41-generic 
492:CONFIG_CRASH_DUMP=y
    ```

3. Update the system

    ```
    apt update
    apt upgrade
    ```

4. Afterwards, reboot the system.

5. If you like remove packages that are no longer needed.

    ```
    apt autoremove
    ```

6. Afterwards, you should be able to follow the steps at https://ruffell.nz/programming/writeups/2019/02/22/beginning-kernel-crash-debugging-on-ubuntu-18-10.html to crash the kernel.

7. When I crashed the kernel, I discovered that I got an OOO:

    ```
    [    0.799715] Out of memory and no killable processes...
[    0.800117] Kernel panic - not syncing: System is deadlocked on memory
[    0.800626] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-53-generic #59-Ubuntu
[    0.801206] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Arch Linux 1.16.0-
    ```

    According to https://ubuntu.com/server/docs/kernel-crash-dump, we should incrase the amount of reserved memory by editing /etc/default/grub.d/kdump-tools.cfg to reserve 512 MB:

    ```
    GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT crashkernel=384M-:512M"
    ```

    This was actually needed for my VM to generate the Kernel Crash Dump file! I can see the file under /var/crash.


8. Net gotcha was an issue installing the vmlinux file with the debuging symbols. Even after following the official steps at https://wiki.ubuntu.com/Kernel/CrashdumpRecipe?action=show&redirect=KernelTeam%2FCrashdumpRecipe, I found that I had to run the following first:

    ```
    apt-get update --allow-insecure-repositories
    ```

Before I could run:

    ```
    sudo apt-get install linux-image-$(uname -r)-dbgsym
    ```

Afterwards, I could launch the crash program. I did not see the Oops message when I ran the log command, but I could see:

    ```
    [   31.275755] sysrq: Trigger a crash
    [   31.276362] Kernel panic - not syncing: sysrq triggered crash
    ```

The bt command doesn't show the Oops either, but I do see that sysrq is suspect:

    ```
    [   31.275755] sysrq: Trigger a crash
    [   31.276362] Kernel panic - not syncing: sysrq triggered crash
    ```

The dis command didn't offer much insight into the issue.

Curious to see if I could have seen similar mesages in the system logs, I checked -- but found none.

I then reran the crash program, and there in front of me was the "root cause":

```
...
       PANIC: "Kernel panic - not syncing: sysrq triggered crash"
         PID: 969
...
```






## References

https://ruffell.nz/programming/writeups/2019/02/22/beginning-kernel-crash-debugging-on-ubuntu-18-10.html