#!/bin/sh

VMS=(kubemaster worker01 worker02)
for vm in "${VMS[@]}"
do
  sudo virsh destroy $vm
done

sleep 30

VMS=(kubemaster worker01 worker02)
for vm in "${VMS[@]}"
do
  sudo virsh undefine $vm
done

