#!/bin/bash

. cluster_param.sh

function check_docker_active {
    array=( $1 )
    for ((i = 0; i < ${#array[@]}; ++i)); do
        array_string=${array[$i]}
        array_arr=(${array_string//;/ })
	echo "[check] checking docker on ${array_arr[1]}@${array_arr[2]}.${machine_domain}"
	ssh ${array_arr[1]}@${array_arr[2]}.${machine_domain} docker ps
    done

}
function check_dns_or_ip {
    array=( $1 )
    for ((i = 0; i < ${#array[@]}; ++i)); do
        array_string=${array[$i]}
        array_arr=(${array_string//;/ })
	echo "[check] checking ip on ${array_arr[2]}.${machine_domain}"
        nslookup ${array_arr[2]}.${machine_domain} | grep -A 2 Name
    done

}

check_docker_active "$(echo ${etcd[@]})"
check_docker_active "$(echo ${controlplane[@]})"
check_docker_active "$(echo ${worker[@]})"

check_dns_or_ip "$(echo ${etcd[@]})"
check_dns_or_ip "$(echo ${controlplane[@]})"
check_dns_or_ip "$(echo ${worker[@]})"
