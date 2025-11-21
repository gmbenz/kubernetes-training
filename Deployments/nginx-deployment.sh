#!/bin/bash
set -x

kubectl apply -f nginx-deployment.yaml
kubectl get deployments
kubectl get pods -l app=nginx