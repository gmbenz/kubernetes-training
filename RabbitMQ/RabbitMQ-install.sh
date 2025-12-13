#!/bin/bash
set -x

kubectl apply -f https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
kubectl get pods -n rabbitmq-system
kubectl apply -f rabbitmq-pvs.yaml
