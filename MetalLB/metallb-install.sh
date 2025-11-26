#!/bin/bash
set -x

helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -n metallb-system --create-namespace
# Configure IP Address Pool
kubectl apply -f ipaddresspool.yaml
# Configure L2 Advertisement
kubectl apply -f l2advertisement.yaml
