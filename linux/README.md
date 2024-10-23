# Linux Tips

- To see what files are consuming the most space in a directory such as /var, run: `du -k /var | sort -nr | more`.

- It can be handy to find out the filesystem when running df. To do this, run `df -T`. 

- The `free` command is not very human-friendly by default, but you can change the units easily buy using `m` or simply `-h` for human-readable.

- The `lsof` command can be used to list open files. With no arguments, it's not very helpful. If you know a user is logged into a system, you can find what files he has opened by running `lsof -u <user>`. Or what if you find a process from top and you want to find what files it has opened. For example, if top lists a process called `Isolated Web Co` with PID 16068, then run `lsof -p 16068` will give you a list of files that process has opeened. See https://www.redhat.com/en/blog/analyze-processes-lsof. 

- The `tcpdump` command can be used to troubleshoot networking issues. For example, on host A, run tcpdump -i <interface> host <source IP>. Then from the source IP machine, run ping <ip.of.host.A>. You should see some output on host A indicating that the ping was successful. See https://hackertarget.com/tcpdump-examples/. Note that if you want to monitor port 22, you should login to the server from the console and not from an SSH session.

- A command that shows what gateway traffic is flowing through is netstat. For example, `netstat -nrv`. If you run `netstat -t` you can see the list of outgoing TCP connections.

- Other commands are: vmstat, iostat, iftop.

- To check all running services, run `systemctl --all`. 

- To reload configurations of services without restarting it, run `systemctl reload <service name>`. This is useful for services such as httpd or sshd for example. For example, by default sshd does not let the root user SSH into the OS. To enable this behavior, edit /etc/ssh/sshd_config and set the property `PermitRootLogin` to true. Then instead of restarting the service you could just reload the service.

- You can enable/disable services by using mask/unmask. In the case of mask, then the service will be started whether or not it is dependent on another service. If you unmask it, then the service will nto be started as a dependency. 

- To make SSH more secure, it is good to set the `ClientAliveInterval` to a value such as 600 or 10 minutes to automatically logout idle SSH sessions. 

- A hidden property is `AllowUsers`. This lets you restrict who can SSH to the server.

- To change the timezone, run `timezonectl list-timezones` to get a list of timezones and then run `timezonectl set-timezone=<timezone>`. 