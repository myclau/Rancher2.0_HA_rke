#!/bin/bash

cd keys

. ../nodeslist.sh
for ((i = 0; i < ${#nodes[@]}; ++i)); do
	ssh-copy-id -i rancher_rsa.pub ${nodes[$i]}
done
