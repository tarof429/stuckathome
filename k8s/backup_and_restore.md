# Backup and Restore

## How to make the backup

A best practice is to store all your definitions in source control. However, even if you don't use source control, you can run the following command to get all your objects to a file.

```sh
kubectl get all --all-namespaces -o yaml > all.yaml
```

Alternatively, you may want to backup etcd. This can be done by either backing up the data directory or taking snapshots. 

To start off,  you need to find the correct path to endpoints, certificates and keys. To find the correct paths, run `kubectl describe pod -n kube-system etcd-controlplane | more`.

For example:

```sh
ETCDCTL_API=3 etcdctl snapshot save /opt/snapshot-pre-boot.db --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key
```

The endpoint does not need to be specified if you are creating the backup on the same server that etcd is running on.

```sh
export ETCDCTL_API=3
etcdctl snapshot save \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key \
    /opt/snapshot-pre-boot.db
```

## How to restore etcd from backup

Run: 

```sh
ETCDCTL_API=3 etcdctl snapshot restore \
    --data-dir /var/lib/etcd-from-backup \
    /opt/snapshot-pre-boot.db 
```

Next, you need to edit the etcd manifest file at /etc/kubernetes/manifests/etcd.yaml and change the hostPath.path of the volume with name etcd-data and set it to /var/lib/etcd-from-backup. 

```yml
  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd    # <- change this
      type: DirectoryOrCreate
    name: etcd-data
```

The kubelet should automatically restart etcd. 

## Troubleshooting after the restore

Run the following command.

```sh
watch crictl ps
```

## Backup and restore of rke2

rke2 from Rancher has a completely different method of doing backup and restore. See https://docs.rke2.io/backup_restore.

## Official documentation

Search for `etcd clusters` at https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/ and scroll down to the section `backing up and etcd cluster`. 



## References

https://github.com/kodekloudhub/community-faq/blob/main/docs/etcd-faq.md