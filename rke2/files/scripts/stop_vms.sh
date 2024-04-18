#!/bin/sh

VMS=(kubemaster worker01 worker02)
for vm in "${VMS[@]}"
do
  sudo virsh shutdown $vm
done