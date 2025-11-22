#!/bin/bash
set -x

# **** Install Kubernetes on RHEL
# Initialize the master
kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up this user to use kubectl for this cluster
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

# Reprint the worker node join command
kubeadm token create --print-join-command
# Join a worker node
kubeadm join k8s-master01:6443 --token <token> --discovery-token-ca-cert-hash <hash>

# List the nodes
kubectl get nodes

# List namespaces
kubectl get namespaces

# List cluster pods
kubectl get pods -n kube-system -o wide

# List flannel pods
kubectl get pods -n kube-flannel -o wide

# **** Deploy something
# Deploy daemon set
kubectl apply -f nginx-daemonset.yaml

# Verify deployment
kubectl get daemonset nginx-on-each-node
kubectl get pods -l app=nginx-on-each-node -o wide

# Delete daemon set
kubectl delete daemonset nginx-on-each-node

# Get the log of the deployment
kubectl describe pod nginx-on-each-node-fxhx9
kubectl logs nginx-on-each-node-fxhx9

# **** Start over
# Reset the master
sudo kubeadm reset --force
sudo rm -rf /etc/cni/net.d
sudo rm -rf /var/lib/cni/
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /etc/kubernetes/
sudo rm -rf $HOME/.kube
sudo rm -rf /run/flannel
sudo systemctl restart containerd
sudo systemctl restart kubelet
sudo ip link delete flannel.1
sudo ip link delete cni0
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo ip6tables -X
sudo ip6tables -t nat -F
sudo ip6tables -t nat -X
sudo ip6tables -t mangle -F
sudo ip6tables -t mangle -X
sudo ip6tables -P INPUT ACCEPT
sudo ip6tables -P FORWARD ACCEPT
sudo ip6tables -P OUTPUT ACCEPT

# Reset the workers
sudo kubeadm reset --force
sudo rm -rf /etc/cni/net.d
sudo rm -rf /var/lib/cni/
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /etc/kubernetes/
sudo rm -rf $HOME/.kube
sudo systemctl restart containerd
sudo systemctl restart kubelet
sudo ip link delete flannel.1
sudo ip link delete cni0
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo ip6tables -X
sudo ip6tables -t nat -F
sudo ip6tables -t nat -X
sudo ip6tables -t mangle -F
sudo ip6tables -t mangle -X
sudo ip6tables -P INPUT ACCEPT
sudo ip6tables -P FORWARD ACCEPT
sudo ip6tables -P OUTPUT ACCEPT