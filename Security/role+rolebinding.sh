#!/bin/bash
set -x

kubectl create namespace dev
kubectl deploy nginx --image=nginx -n dev
kubectl apply -f role.yaml -n dev
kubectl get role -n dev
kubectl apply -f rolebinding.yaml -n dev
kubectl get rolebinding -n dev