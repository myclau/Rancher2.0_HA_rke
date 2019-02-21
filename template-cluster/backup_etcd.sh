#!/bin/bash
rke etcd snapshot-save --name SNAPSHOT$(date +"%Y_%m_%d_%k_%M_%S").db --config cluster.yml
