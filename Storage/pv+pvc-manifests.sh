#!/bin/bash
set -x

kubectl apply -f pv+pvc-manifests.yaml
kubectl get pv
kubectl get pvc