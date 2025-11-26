#!/bin/bash
set -x

kubectl apply -f busybox-stress.yaml

kubectl apply -f stress-ng.yaml

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80
kubectl run curl --image=radial/busyboxplus:curl -i --tty --rm -- curl http://nginx
