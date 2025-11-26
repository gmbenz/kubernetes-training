#!/bin/bash
set -x

# Add helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
# Install Prometheus
helm install prometheus prometheus-community/prometheus
# Create a PV for Prometheus
kubectl apply -f prometheus-pv.yaml
# Verify installation
kubectl get pods -l app.kubernetes.io/name=prometheus
# Port forward to access Prometheus UI
kubectl port-forward svc/prometheus-server 9090:80
# Access Prometheus at http://localhost:9090