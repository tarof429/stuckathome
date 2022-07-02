
# README

The project can be used to create VMs for a Kubernetes cluster. It requires a Linux host with KVM capabilities.

## Create the kubemaster
    
  1. Provision the kubemaster VM.

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n kubemaster -i 192.168.0.30 -u ubuntu -p pass123 -s 40G
    ```

## Create the first node


1. Provision the first Kubernetes worker node

    ```
    sh ./create_seeded_ubuntu_vm.sh  -n worker01 -i 192.168.0.31 -u ubuntu -p pass123 -s 40G
    ```

## Create the second node

1. Provision the second Kubernetes worker node

  ```
  sh ./create_seeded_ubuntu_vm.sh  -n worker02 -i 192.168.0.32 -u ubuntu -p pass123 -s 40G
  ```

## Summary

These steps created three nodes:

kubemaster 192.168.0.30
worker01 192.168.0.31
worker02 192.168.0.32

## Tips and Tricks

- If you are unable to start the VM at a later time because you get the error: 
  
  ```
  error: Cannot access storage file '/tmp/kubemaster/cloud-init.iso': No such file or directory
  ```

  Eject the ISO.

  ```
  sudo virsh change-media kubemaster sda --eject
  ```

  ## Pods

  - The `hello-world-pod` is a simple pod that uses the nginx image. 

    ```
    kubectl apply -f hello-world-pod.yml
    ```

    To show all pods deployed to the cluster, run `kubectl get pod`

    ```
    $ kubectl get pod 
    NAME    READY   STATUS    RESTARTS   AGE
    nginx   1/1     Running   0          15m
    ```

    Since we have two worker nodes, a modified command will show which node it is deployed on.

    ```
    $ kubectl get pod -o wide
    NAME    READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
    nginx   1/1     Running   0          16m   10.42.2.11   worker01   <none>           <none>
    ```

    Now try deploying tghe ngin-pod pod.

    ```
    $ kubectl apply -f hello-world-bad-image-pod.yml 
    pod/ngin-pod created
    [taro@zaxman deployments]$ kubectl get pod -o wide
    NAME       READY   STATUS         RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
    ngin-pod   0/1     ErrImagePull   0          4s    10.42.1.14   worker02   <none>           <none>
    nginx      1/1     Running        0          19m   10.42.2.11   worker01   <none>           <none>
    ```

    In this example, you can see that ngin-pod was unable to downloads the image, and the pod was being deployed on worker02.

    The command below will show more details on why the pod failed to be deployed.

    ```
    $ kubectl describe pod ngin-pod
    ```

    How do you fix this? One way is to edit the pod and edit the image. Wait a few seconds, and the pod will be re-deployed.

    ```
    $ kubectl edit pod ngin-pod
    $ kubectl get pod
    NAME       READY   STATUS    RESTARTS   AGE
    ngin-pod   1/1     Running   0          23m
    nginx      1/1     Running   0          43m
    ```

    Another useful command is `kubectl logs <pod name>`

    ```
    kubectl logs ngin-pod
    ```

    Another useful command is `kubectl exec <pod name> -- <command>`

    ```
    $ kubectl exec ngin-pod -- ls / 
    bin
    boot
    dev
    ...
    ```

    You can also get access to the pod via shell.

    ```
    $ kubectl exec -it ngin-pod -- sh
    # ls
    bin   dev		   docker-entrypoint.sh  home  lib64  mnt  proc  run   srv  tmp  var
    boot  docker-entrypoint.d  etc			 lib   media  opt  root  sbin  sys  usr 
    ```

  Another useful command is `kubectl get pod --watch`. This lets you see the status of pod deployments.

  Sidecars are pods that create more than one container. One such example is provided in `two-containers.yml`. If you deploy it, you'll see that only one pod is in the running state. That's because the debian-container has already exited. 


  ## References

  https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/