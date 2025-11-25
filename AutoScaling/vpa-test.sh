#!/bin/bash
set -x

git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/vertical-pod-autoscaler
./hack/vpa-up.sh

kubectl apply -f vpa-test.yaml
kubectl apply -f vpa.yaml
kubectl describe vpa vpa-test
kubectl get pods -w
