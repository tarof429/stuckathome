# PersistentVolumes (PV)

## Introduction

A PersistentVolume (PV) is a piece of storage in the cluster whose lifecycle is independednt of pods. A PersistentVolumeClaim(PVC) is a request for storage by a user. 

Below is an example of a PersistentVolume.

```yaml
apiVersion: v1
kind: PersistentVolume
metadadta:
    name: pv1
spec:
    accessModes:
        - ReadWriteOnce
    capacity:
        storage: 1Gi
    hostPath:
        path: /data/pv1
```

In Rancher, you may want to bind the PV to a particular server.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
    name: pv1
    namespace: fileserver
    labels:
        type: local
spec:
    capacity:
        storage: 2Gi
    volumeMode: FileSystem
    accessMode:
    - ReadWriteOnce
    persistentVolumeReclaimPolicy: Delete
    storageClass: local-path
    hostPath:
        path: "/data/some-path"
        type: DirectoryOrCreate
    nodeAffiity:
        required:
            nodeSelectorTerms:
            - matchExpressions:
                - key: kubernetes.io/hostname
                    operator: In
                    values:
                    - node01
        claimRef:
            name: pv1
            namespace: fileserver
```  

To create the PV, run:

```sh
kubectl create -f pv1.yaml
```

To list PVs, run:

```sh
kubectl get persistentvolume
```

Next, you need to create a PVC:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: myclaim
    namespace: fileserver
spec:
    accessModes:
        - ReadWriteOnce
    storageClassName: local-path
    resources:
        requests:
            storage: 2Gi
```

If the PVC is deployed and ther are no other claims for 2Gi, then it will claim the PV that has 2Gi available. 

To list PVCs, run:

```sh
kubectl get persistentvolumeclaim
```

By default, persistentVolumeReclaimPolicy is set to Retain. 

An example of a pod that uses a PVC is shown below:

```sh
apiVersion: v1
kind: Pod
metadata:
    name: mypod
spec:
    containers:
        - name: myfrontend
          image: nginx
          volumeMounts:
          - mountPath: "/var/www/html"
            name: mypod
    volumes:
        - name: mypod
          persistentVolumeClaim:
            claimName: myclaim
```


