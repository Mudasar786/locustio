locustio-openshift
==================
Locustio Dockerfile and yaml for deployment in RedHat OpenShift maybe even in Kubernetes 

Locustio is a open source load testing tool created in Python. See https://locust.io/ for more information. 
RedHat OpenShift is a enterprise container orchestration tool developed by RedHat based on Kubernetes. 

This repository contains a Dockerfile to allow you to build your locustio Docker container and yaml files to allow you to deploy the container to your OpenShift/Kubernetes cluster. However I have not tested this in Kubernetes so test/hack/edit/deploy at your own leisure/fustration.

Build Instructions
==================
Download the Dockerfile and update according to your own needs.

My attached Docker file keeps things very simple. It is based on the latest python version and uses the latest alpine OS container to keep things small as possible. 
It installs the required packages for locustio to be able to be installed and run. 
It then creates a /scripts directory which are mounted as volumes so I can inject my test files into my container as a config map. 
I then expose all 3 ports locustio makes use off, so your master and slave both use the same container, however the container roles are defined by what flag is passed to them as an argument which is done from either the master-deployment or slave-deployment yaml files.
The last things we do is ensure we run the conatiner as a locust user rather than running as root. 

Commands to build the container from the same directory as the Dockerfile would be like this (Or you can use my container which is on DockerHub with tags: mudasar786/locust:9-with-gui or mudasar786/locust:9):-
```
$ docker build --no-cache --label locust=9 -t YourDockerHUbUserName/DockerHubRepo:imagetag .
```
e.g
```
$ docker build --no-cache --label locust=9 -t mudasar786/locustio:9 .
```
You should now be able to upload your container to DockerHub:-
```
$ docker push YourDockerHUbUserName/DockerHubRepo:imagetag
```
e.g 
```
$ docker push mudasar786/locustio:9
```

In a few minutes your container with the correct tags will appear on DockerHub

Deployment Instructions
=======================
You can download all the yaml in this repo and then use the kubectl or the oc client for your cluster to deploy the service to your cluster using the following command:-
```bash
oc create -f service.yaml -f tests-configmap.yaml -f locust-configmap.yaml -f master-job.yaml -f slave-job.yaml

or

oc create -f service.yaml -f tests-configmap.yaml -f locust-configmap.yaml -f master-deployment.yaml -f slave-deployment.yaml
```

The 1st line would create a "job" which would run through just the once and then stop.

The 2nd line would create a "deployment" which would run through and then the slave conatiners would just start again. Thats why the above method is prefered. 

It will also create 2 config maps, 1 which has the enviroment variables that will be injected into your pods and another config map which includes the test script to use run your load tests. 

The test scripts should be updated to suit your needs. You should refer to the locustio docs for more information on how to do this.
