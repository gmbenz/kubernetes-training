#!/bin/bash
set -x

# Create StorageClass
kubectl apply -f StorageClass.yaml

# Create 5 PVs
for i in 0 1 2 3 4; do
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-redis-$i
  labels:
    app: redis
spec:
  capacity:
    storage: 20Mi
  accessModes:
    - ReadWriteOnce
  storageClassName: hostpath
  hostPath:
    path: /data/data-redis-$i
    type: DirectoryOrCreate
EOF
done
# Create 5 pvs using Helm chart
helm install redis-pvs ./redis-pv-chart

kubectl apply -f StatefulSetService.yaml
kubectl apply -f StatefulSet.yaml
kubectl get pods -o wide -l app=redis

# Clean up
kubectl delete -f StatefulSet.yaml
kubectl delete pvc -l app=redis
# Delete PVs
for i in 0 1 2 3 4; do
  kubectl delete pv pv-redis-$i
done
# Delete PVs based on app label
kubectl delete pv -l app=redis
# Delete PVs created by Helm chart
helm uninstall redis-pvs