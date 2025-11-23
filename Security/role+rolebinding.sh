#!/bin/bash
set -x

# Create namespace and deploy nginx
kubectl create namespace dev
kubectl create deployment nginx --image=nginx -n dev
kubectl get pods -o wide -n dev

# Apply Role and RoleBinding
kubectl apply -f role.yaml -n dev
kubectl get role -n dev
kubectl describe role -n dev
kubectl apply -f rolebinding.yaml -n dev
kubectl get rolebinding -n dev

# Ask if gmbenz can get and delete pods in dev namespace
kubectl auth can-i get pods --as=gmbenz -n dev
kubectl auth can-i delete pods --as=gmbenz -n dev

# Attempt to delete the nginx pod
pod=$(kubectl get pods -n dev -o jsonpath='{.items[0].metadata.name}')
echo $pod
kubectl delete pod $pod -n dev