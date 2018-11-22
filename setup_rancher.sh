#!/bin/bash
rke up

sleep 30
export KUBECONFIG=$(pwd)/kube_config_cluster.yml
#autoupdate jumpbox default kubeconfig
./updatekubeconfig.sh

kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller \
  --clusterrole cluster-admin \
  --serviceaccount=kube-system:tiller

helm init --service-account tiller
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

# wait for tiller service deploy 
kubectl -n kube-system  rollout status deploy/tiller-deploy
#sleep 60


helm install stable/cert-manager \
  --name cert-manager \
  --namespace kube-system

# to find the version please use helm search rancher-stable/rancher
# to know the chart version go to https://github.com/rancher/server-chart/tree/master and look for the tags
# if you want to use 2.0.8 the version is 2.0.8
# if you want to use 2.1.1 the version is 2018.10.2


helm install rancher-stable/rancher \
  --version 2018.10.2 \
  --name rancher \
  --namespace cattle-system \
  --set tls=external \
  --set hostname=<lb domain> \
  --set privateCA=true \
  --set ingress.tls.source=secret 
#if CA cert use below
#helm install rancher-stable/rancher \
#  --version 2018.10.2 \
#  --name rancher \
#  --namespace cattle-system \
#  --set tls=external \
#  --set hostname=<lb domain>

# you can update the cert location "./loadbalancer/cert/myCA.*"
cp ./loadbalancer/cert/myCA.crt tls.crt
cp ./loadbalancer/cert/myCA.key tls.key

# if your cert is selfsign (if not remove below command)
cp ./loadbalancer/cert/myCA.crt cacerts.pem

kubectl -n cattle-system create secret tls tls-rancher-ingress \
  --cert=tls.crt \
  --key=tls.key

# if your cert is selfsign (if not remove below command)
kubectl -n cattle-system create secret generic tls-ca \
  --from-file=cacerts.pem

rm tls.crt tls.key 
# if your cert is selfsign (if not remove below command)
rm cacerts.pem
