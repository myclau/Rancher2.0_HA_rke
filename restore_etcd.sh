#!/bin/bash
[ "$1" == "$null" ] && exit

rke etcd snapshot-restore --name $1 --config cluster.yml

#need up again
rke up --config cluster.yml
