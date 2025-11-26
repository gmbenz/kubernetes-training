#!/bin/bash
set -x

# Simulate a broken image
kubectl set image deployment/nginx-deploy nginx=nginx:doesnotexist
# Check rollout status
kubectl rollout status deployment/nginx-deploy
kubectl describe deployment nginx-deploy
# Initiate a rollback
kubectl rollout undo deployment/nginx-deploy
# Verify the rollback
kubectl get pods -l app=nginx
kubectl describe deployment nginx-deploy
