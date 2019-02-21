#!/bin/bash
. cluster_param.sh
export KUBECONFIG=$(pwd)/kube_config_cluster.yml

helm init --upgrade --service-account tiller
helm repo update
helm get values rancher

helm  upgrade rancher rancher-stable/rancher \
  --version ${rancher_helm_version} \
  --set tls=external \
  --set hostname=${rancher_domain_name}
