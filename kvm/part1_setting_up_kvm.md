# Part 1: Setting up KVM

## Prerequisites

First, let's check if the CPU supports virtualization. If it's not supported, check in the BIOS to see if this is not enabled.

```bash
$ lscpu | grep Virtualization
Virtualization:                  AMD-V
```

Next, we'll install some packages.

```bash
sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat
```

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
Address=('192.168.1.20/24')
Gateway='192.168.1.1'
DNS=('192.168.1.1')
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
Address='192.168.1.20/24'
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

## Enable the tun module to load at bootup

To create KVMs with bridge network, the tun module must be loaded. Create a file called /etc/modules-lload.d/tun.conf with the following content:

```
$ cat /etc/modules-load.d/tun.conf
# Load the tun module at boot
tun
```

To load the module immediately, run `sudo modprobe tun`
## Create storage pool

First you must create a storage pool. For this exercise, we will create a pool called `default` at `/data/libvirt/default`

```
sudo virsh pool-define-as --name default --type dir --target /data/libvirt/default
```

Afterwards, you should see the pool.


```
$ sudo virsh pool-list --all
 Name      State      Autostart
---------------------------------
 default   inactive   no
```

Next, we need to build the pool.

```
$ sudo virsh pool-start --build default
Pool default started

```

Next, we should configure the pool to autostart.

```
$ sudo virsh pool-autostart default
Pool default marked as autostarted

$ sudo virsh pool-list --all
 Name      State    Autostart
-------------------------------
 default   active   yes
```

We can get some information about the pool.

```
$ sudo virsh pool-info default
Name:           default
UUID:           929dcee8-d935-4e73-aca1-39d13c977529
State:          running
Persistent:     yes
Autostart:      yes
Capacity:       294.23 GiB
Allocation:     2.29 MiB
Available:      294.23 GiB
```

You can see this information in XML format as well.

```
$ sudo virsh pool-dumpxml default
<pool type='dir'>
  <name>default</name>
  <uuid>929dcee8-d935-4e73-aca1-39d13c977529</uuid>
  <capacity unit='bytes'>315926315008</capacity>
  <allocation unit='bytes'>2400256</allocation>
  <available unit='bytes'>315923914752</available>
  <source>
  </source>
  <target>
    <path>/data/libvirt/default</path>
    <permissions>
      <mode>0711</mode>
      <owner>0</owner>
      <group>0</group>
    </permissions>
  </target>
</pool>
```

# References

https://wiki.archlinux.org/title/libvirt

https://computingforgeeks.com/install-kvm-qemu-virt-manager-arch-manjar/

http://thomasmullaly.com/2015/03/29/how-to-put-a-kvm-guest-domain-on-a-bridged-network/


