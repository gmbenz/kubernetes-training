#!/bin/bash
set -x

# Create StorageClass and PVC
kubectl apply -f StorageClass+PVC.yaml

# Create 5 PVs
for i in 0 1 2 3 4; do
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: data-redis-$i
spec:
  capacity:
    storage: 20Mi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data/data-redis-$i
EOF
done

kubectl apply -f StatefulSetService.yaml
kubectl apply -f StatefulSet.yaml
kubectl get pods -l app=redis
