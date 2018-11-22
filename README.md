This project is Demo for Rancher 2.0 HA High Availability (HA) Install

## Current component version
1. Rancher: 2.1.1
2. Helm Chart version: 2018.10.2
3. rke version:
```bash
$ rke version
Server Version: version.Info{Major:"1", Minor:"11", GitVersion:"v1.11.3", GitCommit:"a4529464e4629c21224b3d52edfe0ea91b072862", GitTreeState:"clean", BuildDate:"2018-09-09T17:53:03Z", GoVersion:"go1.10.3", Compiler:"gc", Platform:"linux/amd64"}
```
4. docker version:
```bash
$ docker version
Client:
 Version:           18.06.1-ce
 API version:       1.38
 Go version:        go1.10.3
 Git commit:        e68fc7a
 Built:             Tue Aug 21 17:23:03 2018
 OS/Arch:           linux/amd64
 Experimental:      false

Server:
 Engine:
  Version:          18.06.1-ce
  API version:      1.38 (minimum version 1.12)
  Go version:       go1.10.3
  Git commit:       e68fc7a
  Built:            Tue Aug 21 17:25:29 2018
  OS/Arch:          linux/amd64
  Experimental:     false
```
5. helm version:
```bash
$helm version
Client: &version.Version{SemVer:"v2.11.0", GitCommit:"2e55dbe1fdb5fdb96b75ff144a339489417b146b", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.11.0", GitCommit:"2e55dbe1fdb5fdb96b75ff144a339489417b146b", GitTreeState:"clean"}
```
6. kubectl version:
```bash
$ kubectl version
Client Version: version.Info{Major:"1", Minor:"12", GitVersion:"v1.12.2", GitCommit:"17c77c7898218073f14c8d573582e8d2313dc740", GitTreeState:"clean", BuildDate:"2018-10-24T06:54:59Z", GoVersion:"go1.10.4", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"11", GitVersion:"v1.11.3", GitCommit:"a4529464e4629c21224b3d52edfe0ea91b072862", GitTreeState:"clean", BuildDate:"2018-09-09T17:53:03Z", GoVersion:"go1.10.3", Compiler:"gc", Platform:"linux/amd64"}
```

## Updates
1. As rke add-on is only support up to rancher 2.0.8 so I change the default cluster config not using add-on, and I recommend to use helm install instead of add-on (09 Nov 2018)
2. Modify script to using rancher 2.1.1

## Reference
https://rancher.com/docs/rancher/v2.x/en/installation/ha/


## Infrastructure
We need these machines
1. 1 machine for loadbalance and jump box
2. 3 machine for HA k8s master (role= etcd)
3. 1 machine for role controlplane
3. 1 or more machine for worker

Mininum:
1. 1 machine for loadbalance and jump box
2. 1 machine for role controlplane and etcd
3. 1 or more machine for worker
4. edit cluster.yml for these


## Set up machine
1. create account for all machine , recommend same username password
2. in jumpbox run ssh-keygen and use ssh-copy-id -i ~/.ssh/id_rsa.pub to all machines
3. Git clone project to jumpbox
4. run ./preinstall/preinstall_tool_rancher2.0[_centOS].sh depense on ubuntu or centos in your jump box
5. it will install rke , helm , kubectl into jumpbox
6. run ./preinstall/preinstall_docker_XXX.sh in all machines as all machine need docker.
7. you can scp the install docker script to all node
8. modify the docker script if you need to install specify verion.

## Private easy setup registry (demo purpose / testing purpose)
1. if you need a registry but you dont want to spend too much time for install docker registry with ssl
2. you can go to jumpbox / loadbalancer and use it docker to run ./local_docker_registry/launch_registry.sh
3. make sure if you want to use it in rancher make sure you add the url:port in docker daemon.json of all worker nodes before you run rancher
4. since it need restart docker may make cluster crash.



## First Install Rancher2.0

### common begining steps
1. Login to jump box
2. run create_sshkey.sh to generate key for rke to access all machine
3. update the nodeslist.sh with username@hostname without the jumpbox
4. run ssh_init.sh to ssh-copy-id to all machine 
5. follow the readme to config the loadbalancer 
6. cd to ./ loadbalancer in jumpbox and start by docker command or docker compose
### Install k8s cluster and rancher

Cluster with use rke to install,
For Rancher (below with install them at the same time) 
#### use helm to install rancher to cluster 
7. update cluster.yml with username , hostaddress (must be ip) 
8. make sure the `selfsign cert/ CA cert` is place in somewhere in jumpbox
9. change `cert path` , search and update the `rancher helm chart version` and update `loadbalancer domain` in `setup_rancher.sh`.
10. run ./setup_rancher.sh to install k8s cluster and install rancher

#### use rke to install cluster and rancher (Not recommended as only support up to v2.0.8)
7. In our example is using selfsign cert, if you have ca cert please reference this and edit my cluster.yml template first
```https://rancher.com/docs/rancher/v2.x/en/installation/ha/rke-add-on/layer-7-lb/#5-download-rke-config-file-template```
8. update cluster.yml with username , hostaddress (must be ip) , loadbalance address (must be domain) ,cacert.pem get from step 5
9. also need to copy cluster_addon.yml content at the end of cluster.yml
10. run `rke up`
11. wait it finish

### common checking
12. run ./updatekubeconfig the config for that cluster will be kubectl default config
13. run `kubectl get nodes` you will see
    ```
    NAME        STATUS   ROLES          AGE     VERSION
    host1 ip    Ready    etcd           1m      v1.11.3
    host2 ip    Ready    etcd           1m      v1.11.3
    host3 ip    Ready    etcd           1m      v1.11.3
    host4 ip    Ready    worker         1m      v1.11.3
    host5 ip    Ready    worker         1m      v1.11.3
    host6 ip    Ready    controlplane   1m      v1.11.3
    ```
14. run `kubectl get pods --all-namespaces -o wide` wait all pod completed or running
  ```
    NAMESPACE       NAME                                      READY   STATUS      RESTARTS   AGE   IP    NODE NOMINATED NODE
    cattle-system   rancher-db6cd8bb7-j7wdp                   1/1     Running     1          7m    XXX   XXX  <none>
    cattle-system   rancher-db6cd8bb7-lf9l2                   1/1     Running     1          7m    XXX   XXX  <none>
    cattle-system   rancher-db6cd8bb7-vw6kx                   1/1     Running     1          7m    XXX   XXX  <none>
    ingress-nginx   default-http-backend-797c5bc547-mkfcj     1/1     Running     0          9m    XXX   XXX  <none>
    ingress-nginx   nginx-ingress-controller-p8llh            1/1     Running     0          9m    XXX   XXX  <none>
    ingress-nginx   nginx-ingress-controller-s8cr4            1/1     Running     0          9m    XXX   XXX  <none>
    kube-system     canal-rg8gv                               3/3     Running     0          9m    XXX   XXX  <none>
    kube-system     canal-wdpj5                               3/3     Running     0          9m    XXX   XXX  <none>
    kube-system     canal-zm456                               3/3     Running     0          9m    XXX   XXX  <none>
    kube-system     cert-manager-787d565b77-7t2vk             1/1     Running     0          7m    XXX   XXX  <none>
    kube-system     kube-dns-7588d5b5f5-kxlwr                 3/3     Running     0          9m    XXX   XXX  <none>
    kube-system     kube-dns-autoscaler-5db9bbb766-pxxd4      1/1     Running     0          9m    XXX   XXX  <none>
    kube-system     metrics-server-97bc649d5-6mwnc            1/1     Running     0          9m    XXX   XXX  <none>
    kube-system     rke-ingress-controller-deploy-job-gv47p   0/1     Completed   0          9m    XXX   XXX  <none>
    kube-system     rke-kubedns-addon-deploy-job-7h4jl        0/1     Completed   0          9m    XXX   XXX  <none>
    kube-system     rke-metrics-addon-deploy-job-ss42r        0/1     Completed   0          9m    XXX   XXX  <none>
    kube-system     rke-network-plugin-deploy-job-vz6tv       0/1     Completed   0          9m    XXX   XXX  <none>
    kube-system     tiller-deploy-57f988f854-t7889            1/1     Running     0          8m    XXX   XXX  <none>
  ```
15. check https://lb.somedomain.com again for rancher login page


# Add or remove nodes later one
1. login to jump box
2. modify cluster.yml
3. run `rke up --update-only` under cluster.yml dir

## update Rancher

### update from helm
1. edit version in ./update_rancher.sh
2. run it

### update from rke
1. edit version in cluster.yml add-on session
2. run `rke up --update-only` under cluster.yml dir

#### ps: To find the version please use helm search rancher-stable/rancher
 1. go to https://github.com/rancher/server-chart/tree/master and look for the `tags`
 2. let say 2.0.8 the version is 2.0.8
 3. let say 2.1.1 the version is 2018.10.2


## Horizontal Pod Autoscaler demo
Please look in folder ./hpa_demo


## Known issue setup cluster or Rancher 2.0 itself

1. <del>Duplicate rancher app in k8s cluster and to fix it you can do these:</del>
    1. <del>After install Rancher </del>
    2. <del>Go to rancher </del>
    3. <del>Click cluster's system </del>
    4. <del>Go to Load Balancing, you should see two ingress in Namespace cattle-system</del>
    5. <del>Remove ingress of `cattle-ingress-http` as it is duplicated with `rancher`</del>
    6. <del>You must remove the ingress first</del>
    7. <del>Then go to workloadyou will see there are `cattle` and `rancher` in namespace `cattle-system` and using same image `rancher/rancher:v2.X.X`</del>
    8. <del>remove `cattle` </del>
 
    This issue will happen when you use add-on session to create k8s cluster and ask rke help to install rancher from yml files at the same time use helm to install rancher package.
    Simply said your cluster.yml add-on session have rancher and you also run helm install.
    (Edit on 8 Nov 2018)
    
2. in cluster.yml all the node address please use ip address instead of host name as 
    1. xip.io generation will fail
    2. if you want to expose port in pods for option (NodePort (On every node)), rancher will create the endpoint like http://< null >:randomport
3. <del>if you install kubernetes dashboard through catalog app </del>
    1. <del>the default end point is incorrect should be something like: `https://<rancher-domain>/k8s/clusters/<cluster-name>/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/` </del>
    2. <del>if you go to that url will show 503 no endpoint... </del>
    3. <del>if you run command `kubectl cluster-info | grep dashboard` </del>
    4. <del>you will found something like `https://<some-node-ip>:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:https/proxy` </del>
    5. <del>you will see it missing the https at `/https:kubernetes-dashboard:https/proxy` </del>
    6. <del>so you change the url to this https://<rancher-domain>/k8s/clusters/<cluster-name>/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:`https`/proxy/ </del>
    7. <del>it should work </del>
 This resolve if you set tls correctly. with tls-ca in setup_rancher.sh
4. If you use virtualbox to create vm for playing with rke k8s, please create NAT network (for dns lookup) and Host network (custom static ip), must be in NAT network otherwise after you create the cluster all machine ip will be 10.0.2.15..., and helm install will fail because helm cannot found tiller pod / helm server

5. If you use rke add-on upgrade from 2.0.8 to 2.1.1 , when you add namespace will 100% stuck in activating state. You can follow this to this before upgrade:
  https://rancher.com/docs/rancher/v2.x/en/upgrades/upgrades/migrating-from-rke-add-on/
  
