#!/bin/sh

VMS=(kubemaster kubenode01 kubenode02)
for vm in "${VMS[@]}"
do
  sudo virsh start $vm
  sleep 5
done
