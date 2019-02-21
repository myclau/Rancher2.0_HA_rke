#!/bin/bash

cd keys

. ../cluster_param.sh

function 2darray_operation {
    array=( $1 )
    for ((i = 0; i < ${#array[@]}; ++i)); do
        array_string=${array[$i]}
        array_arr=(${array_string//;/ })
        SSH_OPTS='-F /dev/null'
	echo "copy cert to ${array_arr[1]}@${array_arr[2]}.${machine_domain}"
        ssh-copy-id -i rancher_rsa.pub ${array_arr[1]}@${array_arr[2]}.${machine_domain}
    done

}

2darray_operation "$(echo ${etcd[@]})"
2darray_operation "$(echo ${controlplane[@]})"
2darray_operation "$(echo ${worker[@]})"
