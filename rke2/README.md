# RKE

## Prerequisites

- 3 VMs created as part of the instructions in the k8s directory.

## Verify the Environment

First, let's make sure we can SSH to all the VMs. Use ssh-copy-id to copy your public key to each of the VMs. Afterwards, run:

```
ansible-playbook sshping.yml
```

## Update the nodes

It's not fun if the packages are out of date, so let's update all the VMs.

```
ansible-playbook update.yml
```

## Set up rke2

Run the setup.yml role to setup rke2.

```sh
ansible-playbook setup.yml
```

These are based on the instructions at https://docs.rke2.io/install/quickstart.

## Install kubectl

Install kubectl on your localhost host.

```
sudo pacman -S kubectl
```

## Configure kubectl

1. SSH to kubemaster and copy config.yaml  to your localhost's ~/.kube/config.

```sh
{
mkdir -p ~/.kube
ssh ubuntu@192.168.1.30 "sudo cp /etc/rancher/rke2/rke2.yaml ~/config.yaml"
ssh ubuntu@192.168.1.30 "sudo chown ubuntu:ubuntu ~/config.yaml"
scp ubuntu@192.168.1.30:config.yaml ~/.kube/config
sed -i 's/127.0.0.1/192.168.1.30/' ~/.kube/config
}
````

## Check node status

```sh
kubectl get nodes
```

Eventually the status of the nodes should all be "ready"

## Try it Out

```
$ kubectl run nginx --image=nginx
pod/nginx created
$ kubectl get pods
NAME    READY   STATUS              RESTARTS   AGE
nginx   0/1     ContainerCreating   0          5s
$ kubectl get pods nginx -o wide
NAME    READY   STATUS    RESTARTS   AGE   IP          NODE       NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          19s   10.42.1.3   worker01   <none>           <none>
$ kubectl delete pod nginx
pod "nginx" deleted
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

## How to Install metalLB

See https://www.raptorswithhats.com/gitea-on-rke2-metallb/ for steps on how to install MetallLb. This version will work with rke2; the official one may not. 

Under files/k8s there is a congfigmap.yml file that you can deploy to define your IP ranges. The file files/k8s/nginx-deployment-and-serivce.yml can be used to test that metalLB is working. To test it,

1. Run `kubectl apply -f nginx-deployment-and-service.yml`

2. Run `kubectl get svc` and look for a service called nginx with a type of LoadBalancer

3. In a browser or using curl, navigate to http://<external-ip>.

To delete the service, run `kubectl delete -f nginx-deployment-and-service.yml`


## Questions

- Q: What is the benefit of using k8s? A: k8s provides a framework for coordinating containers from very small deployments all the way to planet-scale. 

- Q: What do you need to run a container? A: A container runtime such as docker, podman, containerd

- Q: What are some benefits of using containers? A: Portability, better resource usage, scalability

- Q: What skills do you need to use k8s? A: Familiarity with the CLI and YAML.

- Q: How can you troubleshoot a deployment? A: Get the name of the pod associated with the deployment. Then run kubectl describe pod <pod name> -n <namespace>.  

- Q: If you have deployment that's not yet exposed to the outside world, how do you verify? A: Spin up a pod running busybox and use wget. Another way is to use the `logs` command.

- Q: You want to deploy MetalLB and you need to find out if your network addon is compatible. How do you find out? A: Add-ons are deployed as pods in the kube-system namespace. Run `kubectl get pods -n kube-system`. 

- Q: How can you view the logs for etcd? A: Run `kubectl logs etcd-kubemaster -n kube-system | jq | more`.


- Q: What components run on all the worker nodes? A: Kubelet, Kube-Proxy, CRI

- Q: Which component communicates directly with the etcd component? A: API Server

- Q: What is the role of the kubelet? A: Check that the containers are healthy.


## Where to go from here

https://www.linkedin.com/learning/paths/getting-started-with-kubernetes

https://www.udemy.com/course/learn-kubernetes/

https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/


## References

https://docs.rke2.io/install/quickstart/