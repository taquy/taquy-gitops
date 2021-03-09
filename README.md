# Get all
```bash
kubectl get all

# Get role binding
kubectl get ClusterRoleBinding

```

# Check volumes of mongodb

```bash
kubectl get persistentvolume
kubectl describe persistentvolume mongo

kubectl get persistentvolumeclaim
kubectl describe persistentvolumeclaim mongo

kubectl get storageclass
kubectl describe storageclass mongo
```
# Check mongodb stateful set

```bash
kubectl get statefulset
kubectl describe statefulset mongo

# check logs
kubectl logs mongo-0 mongo
kubectl logs mongo-0 mongo-sidecar

```