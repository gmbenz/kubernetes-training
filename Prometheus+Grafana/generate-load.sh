#!/bin/bash
set -x

kubectl apply -f busybox-stress.yaml

kubectl apply -f stress-ng.yaml

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80
kubectl run curl --image=radial/busyboxplus:curl -i --tty --rm -- curl http://nginx

# Create Nginx deployment
kubectl create deployment nginx --image=nginx --replicas=2
# Expose port 80 (Uses MetalLB for the load balancer)
kubectl expose deployment nginx --port=80 --type=LoadBalancer
# Run wrk to generate load on Nginx
IPAddress=$(kubectl get svc nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
~/wrk/wrk -t4 -c20 -d10s http://$IPAddress