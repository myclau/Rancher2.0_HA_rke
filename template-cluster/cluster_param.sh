#!/bin/bash
ssh_key_path="./keys/rancher_rsa"
etcd=(
        "ip1;ssh-user;machinename1"
)
controlplane=(
        "ip2;ssh-user;machinename2"
)
worker=(
        "ip3;ssh-user;machinename3"
        "ip4;ssh-user;machinename4"
)
machine_domain="host.domain.com"
rancher_helm_version="2019.1.1"
rancher_domain_name="any.domain.com"

