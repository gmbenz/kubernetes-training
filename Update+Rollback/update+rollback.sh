#!/bin/bash
set -x

# Deploy nginx
kubectl apply -f nginx-deploy.yaml
kubectl get pods -l app=nginx

# Trigger a rolling update
kubectl set image deployment/nginx-deploy nginx=nginx:1.21
kubectl rollout status deployment/nginx-deploy
kubectl get pods -l app=nginx

# Simulate a broken image
kubectl set image deployment/nginx-deploy nginx=nginx:doesnotexist
kubectl rollout status deployment/nginx-deploy
kubectl describe deployment nginx-deploy

# Initiate a rollback
kubectl rollout undo deployment/nginx-deploy
kubectl get pods -l app=nginx
kubectl describe deployment nginx-deploy

kubectl delete -f nginx-deploy.yaml