#!/bin/bash
set -x

# Deploy Metrics Server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm install metrics-server metrics-server/metrics-server -n kube-system --set args={--kubelet-insecure-tls}
kubectl get pods -n kube-system | grep metrics-server
kubectl logs -n kube-system deploy/metrics-server

# Download and build wrk load generator
sudo dnf install perl-File-Find perl-FindBin
git clone https://github.com/wg/wrk.git
cd wrk
make
cd ..

# Create Nginx deployment
kubectl create deployment nginx --image=nginx --replicas=2
# Expose port 80 (Uses MetalLB for the load balancer)
kubectl expose deployment nginx --port=80 --type=LoadBalancer
# Create HPA autoscaling
kubectl autoscale deployment nginx --cpu-percent=50 --min=2 --max=10
# Add resource requests and limits so that metrics server can collect CPU usage
kubectl patch deploy nginx \
  --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/resources","value":{"requests":{"cpu":"100m","memory":"128Mi"},"limits":{"cpu":"200m","memory":"256Mi"}}}]'

# Run wrk to generate load on Nginx
IPAddress=$(kubectl get svc nginx -o jsonpath='{.spec.clusterIP}')
~/wrk/wrk -t4 -c100 -d60s http://$IPAddress

kubectl top nodes
kubectl top pods
