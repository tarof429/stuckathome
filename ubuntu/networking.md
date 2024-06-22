# Networking in Ubuntu

Ubuntu 22 uses netplan to configure network interfaces, but the service that enables networking is usually systemd-networkd. You can view network status by running `networkctl`.

```sh
networkctl
IDX LINK   TYPE     OPERATIONAL SETUP     
  1 lo     loopback carrier     unmanaged
  2 enp1s0 ether    routable    configured

2 links listed.
```

To see details about each link, you can type `networkctl <IDX>`. For example, the 

```sh
root@ubuntu22-test:# networkctl status 2
● 2: enp1s0                                                                    
                     Link File: /usr/lib/systemd/network/99-default.link
                  Network File: /run/systemd/network/10-netplan-enp1s0.network
                          Type: ether
                         State: routable (configured)
                  Online state: online                                         
                          Path: pci-0000:01:00.0
                        Driver: virtio_net
                        Vendor: Red Hat, Inc.
                         Model: Virtio network device
                    HW Address: 52:54:00:00:00:16
                           MTU: 1500 (min: 68, max: 65535)
                         QDisc: fq_codel
  IPv6 Address Generation Mode: eui64
          Queue Length (Tx/Rx): 1/1
              Auto negotiation: no
                         Speed: n/a
                       Address: 192.168.1.33
                                fe80::5054:ff:fe00:16
                       Gateway: 192.168.1.1
                           DNS: 8.8.8.8
                                1.1.1.1
             Activation Policy: up
           Required For Online: yes
             DHCP6 Client DUID: DUID-EN/Vendor:0000ab11ab9226666aea54a00000

Jun 22 20:24:42 ubuntu22-test systemd-networkd[531]: enp1s0: Link UP
Jun 22 20:24:42 ubuntu22-test systemd-networkd[531]: enp1s0: Gained carrier
Jun 22 20:24:43 ubuntu22-test systemd-networkd[531]: enp1s0: Gained IPv6LL
```

The `systemd-resolved` service is responsible for DNS. 

You can use hostnamectl to set the hostname of a machine. Used by itself, hostnamectl can display some useful information.