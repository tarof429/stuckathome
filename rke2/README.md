# RKE

## Create VMs

Follow the steps in the k8s directory to create three VMs for our cluster.

## Set up the nodes

Run the Ansible script to install rke2 on the nodes.

```
ansible-playbook setup.yml
```

Note that this role is VERY basic and you must continue with the post-setup steps, below.

## Post-setup 

1. SSH to kubemaster and copy config.yaml  to your localhost's ~/.kube/config.

    ```
    ssh ubunut@192.168.0.30 "sudo cp /etc/rancher/rke2/rke2.yaml ~/config.yaml"
    ssh ubuntu@192.168.0.30 "sudo chown ubuntu:ubuntu ~/config.yaml"
    scp ubuntu@192.168.0.30:config.yaml ~/.kube/config
    sed -i 's/127.0.0.1/192.168.0.30/' ~/.kube/config
    ```

2. Get the token we need to register the nodes

    ```
    ssh ubuntu@192.168.0.30 "sudo cat /var/lib/rancher/rke2/server/node-token"
    ```


3. Star the agents

    ```
    ansible-playbook register.yml
    ```

## Install kubectl

Install kubectl on your bastion host.

```
sudo pacman -S kubectl
```

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

## References

https://docs.rke2.io/install/quickstart/