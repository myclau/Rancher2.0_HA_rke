#!/bin/bash

export KUBECONFIG=$(pwd)/kube_config_cluster.yml

helm init --upgrade --service-account tiller
helm repo update
helm get values rancher

# to find the version please use helm search rancher-stable/rancher
# to know the chart version go to https://github.com/rancher/server-chart/tree/master and look for the tags
# if you want to use 2.0.8 the version is 2.0.8
# if you want to use 2.1.1 the version is 2018.10.2

helm upgrade rancher rancher-stable/rancher \
   # if your want latest please remove below line
  --version 2018.10.2\
  --name rancher \
  --namespace cattle-system \
  --set tls=external \
  --set hostname=<lb domain> \
  # if your cert is selfsign (if not remove below line)2018.10.2
  --set privateCA=true \
  --set ingress.tls.source=secret 
