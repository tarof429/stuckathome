#!/bin/sh

VMS=(kubemaster worker01 worker02)
for vm in "${VMS[@]}"
do
  sudo virsh destroy $vm
  sudo virsh undefine $vm
done
