#!/bin/bash
set -x

# Since the bare metal cluster does not have a dynamic storage provisioner, we need to create Persistent Volumes (PVs) and prepare them manually.
# Create PVs for Prometheus
kubectl apply -f prometheus-pvs.yaml
# Prepare prometheus directories on nodes. Prometheus runs as user 'nobody'
for i in ezra rugby katana komodo; do echo $i; ssh -qt $i "set -x; sudo mkdir -p /data/prometheus-server /data/persistentvolume-controller; sudo chown -R $(id -u nobody):$(id -g nobody) /data; ls -l /data"; done

# Add helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
# Install Prometheus
helm install prometheus prometheus-community/prometheus
# Verify installation
kubectl get pods -l app.kubernetes.io/name=prometheus
# Port forward to access Prometheus UI
kubectl port-forward svc/prometheus-server 9090:80
# Create a LoadBalancer service to access Prometheus
kubectl apply -f prometheus-lb.yaml
# Access Prometheus at http://localhost:9090

# Get the pod name of the Prometheus server
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
# Describe the Prometheus server pod
kubectl describe $POD_NAME
# Get the logs from the Prometheus server running in the pod
kubectl logs $POD_NAME -c prometheus-server
# Get the id that Prometheus is running as
kubectl exec -it $POD_NAME -- id

helm uninstall prometheus
kubectl delete pvc storage-prometheus-alertmanager-0
kubectl delete -f prometheus-pvs.yaml
for i in ezra rugby katana komodo; do echo $i; ssh -qt $i "set -x; sudo rm -rf /data/prometheus-server /data/persistentvolume-controller; ls -l /data"; done
