#!/bin/sh

VMS=(kubemaster worker01 worker02)
for vm in "${VMS[@]}"
do
  sudo virsh start $vm
  sleep 5
done
