#!/bin/sh

sh ./create_seeded_ubuntu_vm.sh  -n kubemaster -i 192.168.1.30 -u ubuntu -p pass123 -s 40G
sleep 60
    
sh ./create_seeded_ubuntu_vm.sh  -n worker01 -i 192.168.1.31 -u ubuntu -p pass123 -s 40G
sleep 60

sh ./create_seeded_ubuntu_vm.sh  -n worker02 -i 192.168.1.32 -u ubuntu -p pass123 -s 40G
sleep 60