#!/bin/bash

./create_cluster_config.sh
. cluster_param.sh

rke up

sleep 30
export KUBECONFIG=$(pwd)/kube_config_cluster.yml
./updatekubeconfig.sh

kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller \
  --clusterrole cluster-admin \
  --serviceaccount=kube-system:tiller


helm init --service-account tiller
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

kubectl -n kube-system  rollout status deploy/tiller-deploy

#sleep 60

helm install stable/cert-manager \
  --name cert-manager \
  --namespace kube-system

helm install rancher-stable/rancher \
  --version ${rancher_helm_version} \
  --name rancher \
  --namespace cattle-system \
  --set tls=external \
  --set hostname=${rancher_domain_name}



