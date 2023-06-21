# RKE

## Prerequisites

- 3 VMs created as part of the instructions in the k8s directory.

## Setup rke2

Follow the instructions at https://docs.rke2.io/install/quickstart to setup rke2. Use kubeops to run the commands.

Run the following ansible role to SSH to all the nodes.

```
ansible-playbook sshping.yml
```

## Update the nodes

It's not fun if the packages are out of date, so let's update all the VMs.

```
ansible-playbook update.yml
```

## Set up the nodes

Run the Ansible script to install rke2 on the nodes.

```
ansible-playbook setup.yml
```

Note that this role is VERY basic and you must continue with the post-setup steps, below.

## Post-setup 

1. SSH to kubemaster and copy config.yaml  to your localhost's ~/.kube/config.

    ```
    ssh ubuntu@192.168.1.30 "sudo cp /etc/rancher/rke2/rke2.yaml ~/config.yaml"
    ssh ubuntu@192.168.1.30 "sudo chown ubuntu:ubuntu ~/config.yaml"
    scp ubuntu@192.168.1.30:config.yaml ~/.kube/config
    sed -i 's/127.0.0.1/192.168.1.30/' ~/.kube/config
    ```

2. Get the token we need to register the nodes

    ```
    ssh ubuntu@192.168.1.30 "sudo cat /var/lib/rancher/rke2/server/node-token"
    ```


3. Star the agents

    ```
    ansible-playbook register.yml -e "token=<the token>"
    ```

## Install kubectl

Install kubectl on your localhost host.

```
sudo pacman -S kubectl
```

## Check node status

```
kubectl get nodes
```

Eventually the status of the nodes should all be "ready"

## Try it Out

```
kubectl run nginx --image=nginx
pod/nginx created
[taro@zaxman ~]$ kubectl get po
NAME    READY   STATUS              RESTARTS   AGE
nginx   0/1     ContainerCreating   0          5s
[taro@zaxman ~]$ kubectl get po nginx -o wide
NAME    READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          19s   10.42.1.3   worker01   <none>           <none>

```

## Stop the VMs

```
cd files/scripts
sh ./stop_vms.sh
```

## Start the VMs

```
cd files/scripts
sh ./start_vms.sh
```

## References

https://docs.rke2.io/install/quickstart/