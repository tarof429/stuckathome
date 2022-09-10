# Services

A Service is a component in Kubernetes which is used to expose a set of Pods. It is intended to decouple the backend from the front end in what is called a micro-service architecture. Services have three types of Ports:

- NodePort: A port in the range of 30000-32767 that can be accessed by the user

- Port: A port on the service

- TargetPort: A port on the pod itself

There are several types of Services; the important ones are ClusterIP (the default), NodePort, and LoadBalancer. 

- ClusterIP: This type of service exposes Pods within the cluster. 

- NodePort: A Service which exposes nodes at a particular IP on the Node. 

- LoadBalancer: Exposes the Service externally using a cloud provider's load balancer. 

Note that when creating a service, you must use a selector that refers the labels used in the template section of a deployment, or the top-level labels of a pod.


## NodePort

Below is an example of a NodePort:

```
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: myapp
    type: front-end
  ports: 
      # By default and for convenience, the `targetPort` is set to the same value as the `port` field.
    - port: 80
      targetPort: 80
      # Optional field
      # By default and for convenience, the Kubernetes control plane will allocate a port from a range (default: 30000-32767)
      nodePort: 30007
```

This Service would expose the following Pod:

```
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
    type: front-end
spec:
  containers:
  - name: nginx
    image: nginx
```

You can deploy this service and pod using `hello-svc.yml`. Once deployed, you can access it using the curl command with the IP set to either of Nodes, and the port value set to NodePort.

```
$ curl http://192.168.1.31:30007
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
```

## CluserIP

A ClusterIP Service provides a way for Pods to access other Pods using a Selector.

```
apiVersion: v1
kind: Service
metadata:
  name: back-end
spec:
  type: ClusterIP
  selector:
    app: myapp
    type: back-end
  ports:
    - port: 80
      targetPort: 80
```

## LoadBalancer

A LoadBalancer Service tells the cloud-native LoadBalancer how to redirect traffic to a service.