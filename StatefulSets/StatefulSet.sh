#!/bin/bash
set -x

kubectl apply -f StatefulSetService.yaml
kubectl apply -f StatefulSet.yaml
kubectl get pods -l app=redis
