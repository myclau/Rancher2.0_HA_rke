#!/bin/bash

. cluster_param.sh

function 2darray_operation {
   array=( $1 )
   echo "$1"
    for ((i = 0; i < ${#array[@]}; ++i)); do
	
        array_string=${array[$i]}
        array_arr=(${array_string//;/ })
        for ((j = 0; j < ${#array_arr[@]}; ++j)); do
                insert_string="  "
                if [ $j -eq 0 ]
                then
                        insert_string="  - address: ${array_arr[$j]}"
                elif [ $j -eq 1 ]
                then
                        insert_string="    user: ${array_arr[$j]}"
                elif [ $j -eq 2 ]
                then
                        insert_string="    hostname_override: ${array_arr[$j]}"

                fi
                echo -e "$insert_string" >> cluster.yml
        done
        echo -e "    role: [$2]" >> cluster.yml
        echo "" >> cluster.yml
    done

}

rm -f cluster.yml
touch cluster.yml
echo "nodes:" >> cluster.yml
2darray_operation "$(echo ${etcd[@]})" etcd
2darray_operation "$(echo ${controlplane[@]})" controlplane
2darray_operation "$(echo ${worker[@]})" worker

echo "ignore_docker_version: true" >> cluster.yml
echo "" >> cluster.yml
echo "ssh_key_path: $ssh_key_path" >> cluster.yml
echo "" >> cluster.yml
echo "services:" >> cluster.yml
echo -e "  etcd:" >> cluster.yml
echo -e "    snapshot: true" >> cluster.yml
echo -e "    creation: 6h" >> cluster.yml
echo -e "    retention: 24h" >> cluster.yml
echo -e "    extra_args:" >> cluster.yml
echo -e '      election-timeout: "10000"' >> cluster.yml
echo -e '      heartbeat-interval: "2000"' >> cluster.yml
