# RKE

## Create VMs

Follow the steps in the k8s directory to create three VMs for our cluster.

## Set up the nodes

Run the Ansible script to install rke2 on the nodes.

```
ansible-playbook setup.yml
```

Note that this role is VERY basic. 

## Postsetup 

1. SSH to kubemaster and copy /etc/rancher/rke2/rke2.yaml to your localhost's ~/.kube/config.

2. On kubemaster, copy the contents of /var/lib/rancher/rke2/server/node-token

3. Configure the rke2-agent service.

    ```
    mkdir -p /etc/rancher/rke2/
    vim /etc/rancher/rke2/config.yaml
    ```

    Content for config.yaml:

    ```
    server: https://<server>:9345
    token: <token from server node>
    ```


4. Start the service.

    ```
    systemctl start rke2-agent.service
    ```

## Install kubectl

Install kubectl on your bastion host.

```
sudo pacman -S kubectl
```

## References

https://docs.rke2.io/