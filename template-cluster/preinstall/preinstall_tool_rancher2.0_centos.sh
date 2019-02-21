#!/bin/bash
cd ~
wget https://github.com/rancher/rke/releases/download/v0.1.11/rke_linux-amd64 && chmod +x rke_linux-amd64

sudo  mv rke_linux-amd64 /usr/local/bin/rke

wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
tar -zxvf helm-v2.11.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm


chmod +030 /etc/yum.repos.d
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
chmod -030 /etc/yum.repos.d

yum install -y kubectl