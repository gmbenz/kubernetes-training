#!/bin/bash
set -x

# Apply the nginx deployment from the YAML file
kubectl apply -f nginx-deployment.yaml
kubectl get deployments
kubectl describe deployment nginx-deployment
kubectl get pods -o wide -l app=nginx

kubectl delete deployment nginx-deployment
