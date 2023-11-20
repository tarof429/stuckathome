# Part 1: Setting up KVM

## Prerequisites

First, let's check if the CPU supports virtualization. If it's not supported, check in the BIOS to see if this is not enabled.

```bash
$ lscpu | grep Virtualization
Virtualization:                  AMD-V
```

Next, we'll install some packages.

```bash
sudo pacman -S virt-manager qemu vde2 dnsmasq bridge-utils openbsd-netcat dmidecode
```

Choose to install qemu-desktop.

Activate and launch libvirtd

```bash
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
```

The first time I did this, I got warnings about locale not found. This was fixed by setting LANG=C in ~/.bashrc and logging in again.

## Configure the host with a static IP

For this exercise, the host was configured with a static IP address. I followed the instructions at https://ostechnix.com/configure-static-dynamic-ip-address-arch-linux/ using *netctl* and a network profile. It looks something like this:

```
$ cat /etc/netctl/enp37s0 
Description='A basic static ethernet connection'
Interface=enp37s0
Connection=ethernet
IP=static
Address=('192.168.0.22/24')
#Routes=('192.168.0.0/24 via 192.168.1.2')
Gateway='192.168.0.1'
DNS=('8.8.8.8')
```

## Configure Bridge Networking

However, what we want is bridged networking so that KVM guests share the same network as the host. I created another file called *bridge*.

```bash
# cat /etc/netctl/bridge 
Description="Example Bridge connection"
Interface=br0
Connection=bridge
BindsToInterfaces=(enp37s0)
MACAddress='12:34:56:78:90'
IP=static
Address='192.168.1.22/24'
Gateway='192.168.1.1'
DNS='192.168.1.1'
## Ignore (R)STP and immediately activate the bridge
SkipForwardingDelay=yes
```

Note that the name of the interface depends may vary by system.

The *netctl* command should see both profiles. Below, we see that *enp37s0* is enabled while *bridge* is not.

```
# netctl list
* enp37s0
  bridge
```

Stop and disable enp37s0.

```
netctl stop enp37s0
netctl disable enp37s0
```

Enable and start bridge.

```
netctl start bridge
netctl enable bridge
```

Then if we run *ip addr*, we should see our bridge interface configured with a static IP address.

We no longer need enp37s0 and we can remove it.

## Using virsh

In the beginning, you won't have any VMs.

```
$ sudo virsh list --all
 Id   Name   State
--------------------
```

VM images are stored in a storage pool. A pool called *default* stores images under /var/libvirt/images.

```
$ sudo virsh pool-dumpxml default
<pool type='dir'>
  <name>default</name>
  <uuid>07ab343d-1b87-4423-b5d3-f7bcf1551986</uuid>
  <capacity unit='bytes'>526985216000</capacity>
  <allocation unit='bytes'>6695264256</allocation>
  <available unit='bytes'>520289951744</available>
  <source>
  </source>
  <target>
    <path>/var/lib/libvirt/images</path>
    <permissions>
      <mode>0755</mode>
      <owner>0</owner>
      <group>0</group>
    </permissions>
  </target>
</pool>
```



# References

http://thomasmullaly.com/