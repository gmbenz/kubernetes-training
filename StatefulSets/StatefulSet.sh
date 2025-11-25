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

helm install redis-pvs ./redis-pv-chart

kubectl apply -f StatefulSetService.yaml
kubectl apply -f StatefulSet.yaml
kubectl get pods -o wide -l app=redis
