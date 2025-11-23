#!/bin/bash
set -x

kubectl apply -f pvc-mount.yaml
kubectl exec pod-nfs -- sh -c "df -h /data;ls -la /data"
