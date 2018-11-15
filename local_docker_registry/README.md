# Local private registry

1. when you use make sure you go to your worker nodes
2. update /etc/docker/daemon.json
3. ref: https://docs.docker.com/registry/insecure/#deploy-a-plain-http-registry
4. ```
	{
  		"insecure-registries" : ["myregistrydomain.com:5000"]
	}
```
5. `sudo service docker stop`
6. `sudo service docker start`
7. use `docker ps` && `docker pull XXX` to verify is docker run correctly.
