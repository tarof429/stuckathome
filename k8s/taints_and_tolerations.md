# Taints and tolerations

## Introduction

Taints and tolerations work together to help the scheduler schedule pods on nodes. The taint is applied to a node. If a pod is tolerant of the taint, it can be scheduled on the node. Coverseley, if the pod is intolerant of the taint, it cannot be scheduled on the ndoe. 

## Usage

Below is an example on how to apply a taint on a node.

```sh
kubectl taint nodes <node-name> gpu=true:NoSchedule
```

The taint-effect field can have one of three values:

- NoSchedule
- PreferNoSchedule
- NoExecute

Tolerations are defined in the pod defintion file.

```yml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  containers:
  - name: my-app
    image: my-app-image
  tolerations:
  - key: "gpu"
    operator: "Exists"
    effect: "NoSchedule"
```

Another example:

```yml
apiVersion: v1
kind: Pod
metadata:
  name: bee
  labels:
    name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  tolerations:
  - key: "spray"
    operator: "Equal"
    value: "mortein"
    effect: "NoSchedule"
```

Below is an example of removing from node 'controlplane' all the taints with key 'node-role.kubernetes.io/control-plane'

```
$ kubectl taint nodes controlplane node-role.kubernetes.io/control-plane-
```

## Exam notes

If you search for 'taints' on  https://kubernetes.io/, scroll down to the link 'kubectl taint' for good examples of removing a taint. 

Without looking things up line you can run:

```sh
$ kubectl explain pod --recursive| grep -i -B5 toleration
    serviceAccountName	<string>
    setHostnameAsFQDN	<boolean>
    shareProcessNamespace	<boolean>
    subdomain	<string>
    terminationGracePeriodSeconds	<integer>
    tolerations	<[]Toleration>
      effect	<string>
      key	<string>
      operator	<string>
      tolerationSeconds	<integer>
```

## References

https://medium.com/@prateek.malhotra004/demystifying-taint-and-toleration-in-kubernetes-controlling-the-pod-placement-with-precision-d4549c411c67

https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/

https://kubernetes.io/docs/reference/kubectl/generated/kubectl_taint/

