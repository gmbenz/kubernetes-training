#!/bin/bash
set -x

# Install RabbitMQ Cluster Operator
kubectl apply -f https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
kubectl get pods -n rabbitmq-system
# Create Persistent Volumes, RabbitMQ Cluster, and Management UI
kubectl apply -f rabbitmq-pvs.yaml
kubectl apply -f fix-permissions.yaml
# Create RabbitMQ Cluster
kubectl apply -f rabbitmq.yaml
kubectl get pods -l app.kubernetes.io/name=rabbitmq -o wide
# Create Load Balancer for Management UI
kubectl apply -f rabbitmq-management-ui-load-balancer.yaml
kubectl get svc rabbitmq-management
# Get default username and password
kubectl get secret rabbitmq-default-user -o jsonpath='{.data.username}' | base64 --decode; echo
kubectl get secret rabbitmq-default-user -o jsonpath='{.data.password}' | base64 --decode; echo
# Login to Management UI at http://<EXTERNAL-IP>:15672
