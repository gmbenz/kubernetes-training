#!/bin/bash
set -x

# Deploy nginx
kubectl create deployment nginx --image=nginx:latest
# Expose nginx via ClusterIP
kubectl apply -f service-clusterip.yaml
kubectl get svc nginx-clusterip
# Test access to Nginx via curl from within the cluster
kubectl run curlpod --image=curlimages/curl:latest -it --rm --restart=Never -- curl http://nginx-clusterip

kubectl delete svc nginx-clusterip
kubectl delete deployment nginx