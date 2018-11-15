# Steps

# Make a self sign cert
1. cd ./cert
2. sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout myCA.key -out myCA.crt

# Have CA cert
1. put cert into ./cert/myCA.crt must in pem format
2. put key into ./cert/myCA.key must in pem format

# common steps
3. if you use rke add-on install rancher
  1. cat myCA.crt | base-64 -w0 , copy the value to cluster_addon.yml <cacerts.pem>
4. edit ./nginx/conf.d/rancher.conf
5. you need to map all machine for rancher ingress , it should be all ip address of worker nodes
6. run docker-compose up -d or docker_run.sh (prefer)



