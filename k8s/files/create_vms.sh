#!/bin/sh

echo "Creating VMs"
sh ./create_seeded_ubuntu_vm.sh  -n kubemaster -i 192.168.1.30 -u ubuntu -p pass123 -s 40G
sh ./create_seeded_ubuntu_vm.sh  -n worker01 -i 192.168.1.31 -u ubuntu -p pass123 -s 40G
sh ./create_seeded_ubuntu_vm.sh  -n worker02 -i 192.168.1.32 -u ubuntu -p pass123 -s 40G

sleep 30
echo "Shutting down VMs"
ssh -o StrictHostKeyChecking=no ubuntu@192.168.1.30 sudo /sbin/shutdown -h now
ssh -o StrictHostKeyChecking=no ubuntu@192.168.1.31 sudo /sbin/shutdown -h now
ssh -o StrictHostKeyChecking=no ubuntu@192.168.1.32 sudo /sbin/shutdown -h now

sleep 30
echo "Starting VMs"
sudo virsh start kubemaster
sudo virsh start worker01
sudo virsh start worker02