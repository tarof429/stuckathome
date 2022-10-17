# How to Install Ubuntu over the network

## Components

### DHCP Server

The first thing you need is a DHCP server.

### TFTP Server

You also need a TFTP server that will host PXELINUX which the remote system will use to retrieve the ISO hosted by a web server.

### HTTP Server

The HTTP hosts the ISO and kickstart file.

### Setting up a DHCP Server on Ubuntu

First you should configure your host with a static IP. There are two reasons for doing this:

- The package we will use to run a DNS server, dnsmasq, has a port conflict if your host is also using DHCP
- Clients will need a DNS server with a static IP

#### Steps:

1. First, let's configure a static IP. Edit /etc/netplan/netplan-1-netcfg.yaml (or something similar) so that it looks something like this:

```
network:
  ethernets:
    enp3s0:
      dhcp4: false
      addresses:
        - 192.168.1.44/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
  version: 2
```

Once, done, save the file and apply changes:

```
sudo netplan apply
```

2. Next, we need to disable systemd-resolved since it binds to port 53, which will also be used by dnsmasq.

```
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
```

3. Next, create resolv.conf

```
echo nameserver 8.8.8.8 | sudo tee /etc/resolv.conf
```

4. Next, isntall dnsmasq.

```
sudo apt update
sudo apt install dnsmasq
```

5. Next, configure dnsmasq.

```
sudo vi /etc/dnsmasq.conf
```

Here is a minimal configuration.

```
# Listen on this specific port instead of the standard DNS port
# (53). Setting this to zero completely disables DNS function,
# leaving only DHCP and/or TFTP.
port=53
# Never forward plain names (without a dot or domain part)
domain-needed
# Never forward addresses in the non-routed address spaces.
bogus-priv
# By  default,  dnsmasq  will  send queries to any of the upstream
# servers it knows about and tries to favour servers to are  known
# to  be  up.  Uncommenting this forces dnsmasq to try each query
# with  each  server  strictly  in  the  order  they   appear   in
# /etc/resolv.conf
strict-order
# Set this (and domain: see below) if you want to have a domain
# automatically added to simple names in a hosts-file.
expand-hosts
# Set the domain for dnsmasq. this is optional, but if it is set, it
# does the following things.
# 1) Allows DHCP hosts to have fully qualified domain names, as long
#     as the domain part matches this setting.
# 2) Sets the "domain" DHCP option thereby potentially setting the
#    domain of all systems configured by DHCP
# 3) Provides the domain part for "expand-hosts"
#domain=thekelleys.org.uk
domain=example.com

# Set Listen address
listen-address=127.0.0.1 # Set to Server IP for network responses
```

After making changes, restart the dnsmasq service.


## References

https://ubuntu.com/server/docs/install/netboot-arm64

https://computingforgeeks.com/install-and-configure-dnsmasq-on-ubuntu/
