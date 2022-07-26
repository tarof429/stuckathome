# Namespaces

All clusters have namespaces. Let's see what namespaces exist for a cluster created with rke2.

```
kubectl get ns
NAME              STATUS   AGE
default           Active   17d
ingress-nginx     Active   17d
kube-node-lease   Active   17d
kube-public       Active   17d
kube-system       Active   17d
```

By default, newly created objects are put in the `default` namespace. Let's try creating a pod on the fly.

```
$ kubectl run nginx --image=nginx
pod/nginx created
```

Let's see what namespace the pod was created in.

```
$ kubectl describe pod nginx |grep -i namespace
Namespace:    default
```

We can get some basic information about a namespace.

```
$ kubectl describe ns default
Name:         default
Labels:       kubernetes.io/metadata.name=default
Annotations:  <none>
Status:       Active

No resource quota.

No LimitRange resource.
```

## Example: Change the namespace of a pod

Let's create two namespaces: dev and test

```
$ kubectl create ns dev
namespace/dev created
$ kubectl create ns test
namespace/test created
```

Now edit the nginx pod and move it to the test namespace. The following error happens.

```
$ kubectl edit pod nginx
A copy of your changes has been stored to "/tmp/kubectl-edit-2760946362.yaml"
error: the namespace from the provided object "test" does not match the namespace "default". You must pass '--namespace=test' to perform this operation.
```

One way to fix this is to delete the old pod and redeploy a new one. First, get the yaml file of the existing pod.

```
kubectl get pod nginx -o yaml > mypod.yml
```

Edit the pod until we get something like this:

```
apiVersion: v1
kind: Pod
metadata:
    namespace: default
    name: nginx
spec:
  containers:
  - image: nginx
    imagePullPolicy: Always
    name: nginx
```

Now delete the old pod.

```
kubectl delete pod nginx
```

Edit the yaml file so that the namespace is changed to `test`. 

Now deploy the pod.

We need to specify the namespace to see it.

```
$ kubectl get pod -n test
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          91s
```

If you don't know which namespace the pod is in, you can specify all.

```
$ kubectl get pod --all-namespaces
NAMESPACE       NAME                                      READY   STATUS      RESTARTS         AGE
ingress-nginx   ingress-nginx-admission-create-2bnfm      0/1     Completed   0                17d
ingress-nginx   ingress-nginx-admission-patch-9bwdj       0/1     Completed   2                17d
ingress-nginx   nginx-ingress-controller-757f4            1/1     Running     6 (5d17h ago)    17d
ingress-nginx   nginx-ingress-controller-9r58l            1/1     Running     6 (5d17h ago)    17d
kube-system     calico-kube-controllers-fc7fcb565-cmxtk   1/1     Running     10 (18m ago)     17d
kube-system     canal-jvjkv                               2/2     Running     12 (5d17h ago)   17d
kube-system     canal-tnbp6                               2/2     Running     12 (5d17h ago)   17d
kube-system     canal-wrpnz                               2/2     Running     12 (5d17h ago)   17d
kube-system     coredns-548ff45b67-ffbwz                  1/1     Running     6 (5d17h ago)    17d
kube-system     coredns-548ff45b67-lbbd7                  1/1     Running     6 (5d17h ago)    17d
kube-system     coredns-autoscaler-d5944f655-c55zh        1/1     Running     6 (5d17h ago)    17d
kube-system     metrics-server-5c4895ffbd-2vh6x           1/1     Running     6 (5d17h ago)    17d
kube-system     rke-coredns-addon-deploy-job-crx4k        0/1     Completed   0                17d
kube-system     rke-ingress-controller-deploy-job-slc79   0/1     Completed   0                17d
kube-system     rke-metrics-addon-deploy-job-hffxx        0/1     Completed   0                17d
kube-system     rke-network-plugin-deploy-job-d8krj       0/1     Completed   0                17d
test            nginx                                     1/1     Running     0                3m9s
```

It can be tedious to constantly specify a namespace. Edit ~/.kube/config and specify a namespace. This can be verified by running `kubectl config view`.

Alternatively, you can use an obscure kubectl command.

```
kubectl config set-context --current --namespace=default
```

Namespaces can be created declaratively. Create a file with the following content and deploy it.

```
$ cat myns.yml 
apiVersion: v1
kind: Namespace
metadata:
  name: prod
```

Afterwards, we can see that the namespace was created.

```
$ kubectl apply -f myns.yml 
namespace/prod created
$ kubectl get ns
NAME              STATUS   AGE
default           Active   17d
ingress-nginx     Active   17d
kube-node-lease   Active   17d
kube-public       Active   17d
kube-system       Active   17d
prod              Active   4s
```


## Cleanup

Delete our pod.

```
$ kubectl delete -f mypod.yml 
pod "nginx" deleted
```

Delete our namespaces.

```
$ kubectl delete ns dev
namespace "dev" deleted
$ kubectl delete ns test
namespace "test" deleted
$ kubectl delete ns prod
namespace "prod" deleted
```


## References

https://kubernetes.io/docs/tasks/administer-cluster/namespaces
