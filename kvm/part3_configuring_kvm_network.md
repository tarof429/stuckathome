# Part 3: Configuring Network

This section explains how to set a static IP for CentOS.

1. Edit /etc/sysconfig/network-scripts/ifcfg-eth0.

```
cat << END > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
ONBOOT="yes"
NM_CONTROLLD="no"
NETBOOT=no
IPV6INIT="yes"
BOOTPROTO="static"
TYPE="Ethernet"
NAME="eth0"
DNS1="8.8.8.8"
IPADDR="192.168.0.23"
NETMASK="255.255.255.0"
END

2. Edit /etc/sysconfig/network

```
cat << END > /etc/sysconfig/network
GATEWAY=192.168.0.1
END
```

3. Set hostname

```
hostnamectl set-hostname test
```

6. Edit /etc/hosts

```
cat << END > /etc/hosts
127.0.0.1	localhost
::1		localhost
192.168.0.23	test
END
```

4. Enable SSH login using password.

```
{
sed 's|PasswordAuthentication no|PasswordAuthentication yes|' /etc/ssh/sshd_config > /etc/ssh/sshd_config.new
mv -f /etc/ssh/sshd_config.new /etc/ssh/sshd_config
}
```

5. Create a non-root user.

```
{
useradd -m taro
usermod -aG wheel taro
}
```

Be sure to set a password for the non-root user.

6. Reboot