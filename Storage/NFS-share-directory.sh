#!/bin/bash
set -x

# Set this up on ubuntu.internal-domain.net
sudo apt update
sudo apt install nfs-kernel-server -y
sudo mkdir -p /srv/nfs/kubedata
sudo chown nobody:nogroup /srv/nfs/kubedata
echo "/srv/nfs/kubedata *(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
sudo exportfs -rav
