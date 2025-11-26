#!/bin/bash
set -x

# Deploy nginx
kubectl apply -f nginx-deploy.yaml
kubectl get pods -l app=nginx

# Trigger a rolling update
kubectl set image deployment/nginx-deploy nginx=nginx:1.21
kubectl rollout status deployment/nginx-deploy
kubectl get pods -l app=nginx