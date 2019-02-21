#!/bin/bash
mkdir -p keys
cd keys
ssh-keygen -t rsa -b 4096 -N '' -f rancher_rsa
cat rancher_rsa
cat rancher_rsa.pub
