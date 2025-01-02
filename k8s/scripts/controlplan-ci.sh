#!/bin/bash

# https://github.com/cri-o/packaging/blob/main/README.md
apt-get update
apt-get install -y \
    software-properties-common \
    bash-completion \
    curl \
    jq

KUBERNETES_VERSION=v1.30
PROJECT_PATH=prerelease:/main

curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/$PROJECT_PATH/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

apt-get update
apt-get install -y cri-o kubelet kubeadm kubectl

systemctl daemon-reload
systemctl enable --now crio.service

swapoff -a
modprobe br_netfilter
sysctl -w net.ipv4.ip_forward=1

local_ip=$(ip --json addr show eth0 | jq -r '.[0].addr_info[] | select(.family == "inet") | .local')

echo "KUBELET_EXTRA_ARGS=--node-ip=$local_ip" | sudo tee /etc/default/kubelet > /dev/null

# kubeadm init

# export KUBECONFIG=/etc/kubernetes/admin.conf

# https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml

echo 'source <(kubeadm completion bash)' |tee -a "$HOME/.bashrc"
echo 'source <(kubectl completion bash)' |tee -a "$HOME/.bashrc"
