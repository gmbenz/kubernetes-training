#!/bin/bash
set -x

kubectl apply -f service-clusterip.yaml
kubectl get svc nginx-clusterip
kubectl run curlpod --image=curlimages/curl:latest -it --rm --restart=Never -- curl http://nginx-clusterip
kubectl delete service nginx-clusterip