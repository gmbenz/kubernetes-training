#!/bin/bash
set -x

# Create a deployment named nginx using the nginx:latest image
kubectl create deployment nginx --image=nginx:latest
kubectl get deployments
kubectl describe deployment nginx
kubectl get pods -o wide -l app=nginx

# Scale the deployment to 3 replicas
kubectl scale deployment nginx --replicas=3
kubectl get pods -o wide -l app=nginx

# Label all nginx pods with tier=frontend
for i in $(kubectl get pods -l app=nginx -o jsonpath='{.items[*].metadata.name}'); do
    kubectl label pod $i tier=frontend
done
kubectl get pods --show-labels
kubectl get pods -l tier=frontend

# Delete one of the nginx pods to demonstrate self-healing
$first_pod=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod $first_pod
kubectl get pods -o wide -l app=nginx

# Delete the deployment
kubectl delete deployment nginx
kubectl get deployments