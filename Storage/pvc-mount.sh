#!/bin/bash
set -x

kubectl apply -f pvc-mount.yaml
kubectl get pods