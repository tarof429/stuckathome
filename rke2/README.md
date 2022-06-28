# RKE

## Create VMs

Follow the steps in the k8s directory to create three VMs appropriate for our cluster.

## Set up each node

An ansible script has been set up to configure the nodes for Kubernetes.

```
ansible-playbook setup.yml
```

## Configure the cluster

```
rke config
```

## Bring up the cluster

```
rke up
```

## Install kubectl

Install kubectl on your bastion host.

```
sudo pacman -S kubectl
```

## Verify the cluster

For some reason, rke creates cluster.yml in the home directory with the name kube_config_cluster.yml. You need to pass this filename to kubectl to interact with the cluster.

```
kubectl --kubeconfig kube_config_cluster.yml version
```

To make it easier for yourself, create a directory called .kube and put the file there.

```
mkdir ~/.kube
mv ~/kube_config_cluster.yml ~/.kube/config
```

