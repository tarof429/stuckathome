# Linux Tips

## Files and Processes

- To see what files are consuming the most space in a directory such as /var, run: `du -k /var | sort -nr | more`.

- It can be handy to find out the filesystem when running df. To do this, run `df -T`. 

- The `free` command is not very human-friendly by default, but you can change the units easily buy using `m` or simply `-h` for human-readable.

- The `lsof` command can be used to list open files. With no arguments, it's not very helpful. If you know a user is logged into a system, you can find what files he has opened by running `lsof -u <user>`. Or what if you find a process from top and you want to find what files it has opened. For example, if top lists a process called `Isolated Web Co` with PID 16068, then run `lsof -p 16068` will give you a list of files that process has opeened. See https://www.redhat.com/en/blog/analyze-processes-lsof. 

- The `tcpdump` command can be used to troubleshoot networking issues. For example, on host A, run tcpdump -i <interface> host <source IP>. Then from the source IP machine, run ping <ip.of.host.A>. You should see some output on host A indicating that the ping was successful. See https://hackertarget.com/tcpdump-examples/. Note that if you want to monitor port 22, you should login to the server from the console and not from an SSH session.

- A command that shows what gateway traffic is flowing through is netstat. For example, `netstat -nrv`. If you run `netstat -t` you can see the list of outgoing TCP connections.

- Other commands are: vmstat, iostat, iftop.

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
- To create a local repo, follow these steps (for AlmaLinux 9):

    - Install createrepo package
    - Create a directory called /iso
    - Mount the AlmaLinux 9 ISO to /iso
    - Create a directory called /localrepo
    - Create a directory called /localrepo/BaseOS
    - Copy /iso/BaseOS/Packages to /localrepo/BaseOS/Packages
    - Run createrepo Packages -o .
    - Create a directory called /localrepo/AppStream
    - Copy /iso/AppStream/Packages to /localrepo/AppStream/Packages
    - Run createrepo Packages -o .
    - Go to /etc/yum.repos.d
    - Create a directory called old
    - Move all the *.repo files to old
    - Copy old/rocky.repo to the parent directory
    - Edit this file and point baseurl for the BaseOS and AppStream repositories
    - Finally verify the repostories by running `dnf repolist -v`

- A handy CLI to know is `dnf config-manager`. For example, to enable a yum repo, run `dnf config-manager --set-enabled baseos`.