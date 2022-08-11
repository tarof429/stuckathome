#!/bin/sh

sh ./create_seeded_ubuntu_vm.sh  -n kubemaster -i 192.168.0.30 -u ubuntu -p pass123 -s 40G
sleep 5
    
sh ./create_seeded_ubuntu_vm.sh  -n worker01 -i 192.168.0.31 -u ubuntu -p pass123 -s 40G
sleep 5

sh ./create_seeded_ubuntu_vm.sh  -n worker02 -i 192.168.0.32 -u ubuntu -p pass123 -s 40G
sleep 5