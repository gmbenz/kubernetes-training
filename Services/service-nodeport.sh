#!/bin/bash
set -x

# Expose Nginx via NodePort
kubectl create deployment nginx --image=nginx:latest
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl get svc

# Test access to Nginx via curl from within the cluster
kubectl run curlpod --image=curlimages/curl:latest -it --rm --restart=Never -- curl http://nginx

# Test access to Nginx via curl from outside the cluster
node=$(kubectl get pods -l app=nginx -o jsonpath='{range .items[*]}{.status.hostIP}')
port=$(kubectl get svc nginx -o jsonpath='{.spec.ports[0].nodePort}')
echo "node=$node"
echo "port=$port"
curl http://$node:$port

kubectl delete svc nginx
kubectl delete deployment nginx