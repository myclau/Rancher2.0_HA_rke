# Step

1. Make a self sign cert
2. create folder: mkdir cert
3. cd ./cert
4. sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout myCA.key -out myCA.crt
5. cat myCA.crt | base-64 -w0 , copy the value to cluster.yml <cacerts.pem>
6. edit ./nginx/conf.d/rancher.conf
7. you need to map all machine for rancher ingress , it should be all ip address of worker nodes
8. run docker-compose up -d
9. you can find it by using 
```
kubectl get ingress --all-namespaces
```
10. you will see 
```
NAMESPACE       NAME                  HOSTS	    ADDRESS		        PORTS	AGE
cattle-system   cattle-ingress-http   lddomain	host1,host2,host3	80	  26m
cattle-system   rancher               lddomain	host1,host2,host3	80	  26m
```
11. double check it with rancher.conf host1,host2,host3 should have worker role


