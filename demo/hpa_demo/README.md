# HPA 

## Ref
https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/

## Step
1. run command to create hello-world app
`kubectl create -f hello_world.yml`
2. use ingress to generate layer7 endpoint to hello-world app
3. install go and hey one by one by using ./tool/*.sh
4. run command to create hpa for hello-world app
`kubectl create -f hpa_hello_world.yml`
5. run hey command to load the hello-world app
`hey -n 100000 https://url-of-your-hello-world-app`
6. go to rancher / kubernetes dashboard you will see the number of pod will increase
7. after a while as not request is requesting for hello-world so it will drop to 1 pods
8. To check event log:
	1. you can go to dashboard
	2. or run command
		`kubectl describe hpa hello-world`
