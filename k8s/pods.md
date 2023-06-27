# Pods

## The pod

A pod is the simplest unit that can be deployed to containers. Most pods consist of only one container, but it is possible to deploy multiple containers. A pod runs on a worker node.

### Creating a basic Nginx Pod

The easiest way to run a docker image as a pod in Kubernetes is to use the imperative command:

```
kubectl run nginx --image nginx
pod/nginx created
```

This command tells kubectl to create a pod called `nginx` using the nginx image. This method is useful to know on the CKE.

Now let's see if this command really worked.

```
$ kubectl get pod
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          8s
```

Yes it did!

### Creating a pod yaml file without actually creating the pod

It can be useful to run a command to create a yaml file without actually creating the pod.

```
kubectl run nginx --image=nginx --dry-run=client -o yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

You can redirect the output to a file, edit the file, and then deploy the file.

### Creating a pod using a yaml file

The `hello-world-pod` is a simple pod that uses the nginx image. 

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

  Now lets try another example.

  ```
  $ kubectl apply -f hello-world-bad-image-pod.yml 
  pod/ngin-pod created
  [taro@zaxman deployments]$ kubectl get pod -o wide
  NAME       READY   STATUS         RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
  ngin-pod   0/1     ErrImagePull   0          4s    10.42.1.14   worker02   <none>           <none>
  nginx      1/1     Running        0          19m   10.42.2.11   worker01   <none>           <none>
  ```

 You can see that nginx-pod was unable to downloads the image, and the pod was being deployed on worker02.

  The command below will show more details on why the pod failed to deploy, and where.

  ```
  $ kubectl describe pod nginx-pod
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

## Kubernetes POD YAML

Let's take a closer look at the syntax of a YAML definition of a pod. All pods need four sections as illustrated in `hello-world-pod.yml`: apiVersion, kind, metadata, and spec.

```
apiVersion: v1
kind: Pod 
metadata:
  name: nginx
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
      - containerPort: 80
```

You can see this structure at `https://kubernetes.io/docs/concepts/workloads/pods/` so you don't have to memorize every detail. The `apiVersion` and `kind` fields are key/value pairs. However, note the indentation for metadata. The metadata field is a dictionary.

If you create a Kubernetes object using a text editor like vi, it is recommnded to use two spaces instead of tabs to avoid a syntax error.

The apiVersion for a pod is always v1. The kind is Pod. Since the metadata field is a dictionary, you need to add indentation and then add key/value pairs.  It is common to have an embedded dictionary called `labels`. For example:

```
metadata:
  name: myapp-pod
  labels:
    app: myapp
```

Containers is an array/list. Each element needs to be prefixed by a dash.

Here's another example:

```
apiVersion: v1
kind: Pod
metadata:
  name: postgres
  labels:
    tier: db-tier
spec:
  containers:
    - name: postgres
      image: postgres
```

Here's another example:

```
apiVersion: v1
kind: Pod
metadata:
  name: postgres
  labels:
    tier: db-tier
spec:
  containers:
    - name: postgres
      image: postgres
      env:
        - name: POSTGRES_PASSWORD
          value: mysecretpassword
```

## Sidecar Pod

Sidecars are pods that create more than one container. One such example is provided in `two-containers.yml`. If you deploy it, you'll see that only one pod is in the running state. That's because the debian-container has already exited. 

Below is another example of sidecar containers. 

```
cd deployments
kubectl apply -f sidecar.yml
```

This deploys a pod with two containers. 

```
$ kubectl get pods
NAME            READY   STATUS    RESTARTS   AGE
sidecar-pod-1   2/2     Running   0          110s
```

Let's see what pods were deployed.

```
$ kubectl describe pod sidecar-pod-1
...
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m29s  default-scheduler  Successfully assigned default/sidecar-pod-1 to worker01
  Normal  Pulling    3m28s  kubelet            Pulling image "busybox"
  Normal  Pulled     3m25s  kubelet            Successfully pulled image "busybox" in 2.543143233s
  Normal  Created    3m25s  kubelet            Created container application
  Normal  Started    3m25s  kubelet            Started container application
  Normal  Pulling    3m25s  kubelet            Pulling image "busybox"
  Normal  Pulled     3m24s  kubelet            Successfully pulled image "busybox" in 1.074386735s
  Normal  Created    3m24s  kubelet            Created container sidecar
  Normal  Started    3m24s  kubelet            Started container sidecar
```

Now lets see the logs in the sidecar container.

```
kubectl logs sidecar-pod-1 -c sidecar
Thu Jul  7 05:16:28 UTC 2022 INFO hello
```

Run this a few times to see more logs.

Finaly, delete the pod.

```
$ kubectl delete -f sidecar.yml 
pod "sidecar-pod-1" deleted
```

The key takeways are:

- Sidecar is a pattern where two or more containers are deployed in a pod.

- The sidecar pattern is useful when two containers are tightly coupled.

## Exercises

1. Suppose you have a pod called webapp. How can you find out what images are used in the webapp? Answer: run kubectl describe pod webapp | more.