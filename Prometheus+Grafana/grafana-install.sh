#!/bin/bash
set -x

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana
kubectl get pods -l app.kubernetes.io/name=grafana
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl describe $POD_NAME
kubectl logs $POD_NAME -c grafana
# Run the health check
export POD_IP=$(kubectl get pod $POD_NAME -o wide -o jsonpath="{.status.podIP}")
curl http://$POD_IP:3000/api/health

export SECRET=$(kubectl get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode)

kubectl apply -f grafana-lb.yaml
LBIP=$(kubectl get svc grafana-lb -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo "Grafana is accessible at http://$LBIP:3000"

# [gmbenz@manatee Prometheus+Grafana]$ helm install grafana grafana/grafana
# NAME: grafana
# LAST DEPLOYED: Wed Nov 26 13:20:09 2025
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# NOTES:
# 1. Get your 'admin' user password by running:

#    kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# 2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

#    grafana.default.svc.cluster.local

#    Get the Grafana URL to visit by running these commands in the same shell:
#      export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
#      kubectl --namespace default port-forward $POD_NAME 3000

# 3. Login with the password from step 1 and the username: admin
# #################################################################################
# ######   WARNING: Persistence is disabled!!! You will lose your data when   #####
# ######            the Grafana pod is terminated.                            #####
# #################################################################################
