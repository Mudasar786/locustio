locustio-openshift
==================
Locustio Dockerfile and yaml for deployment in RedHat OpenShift maybe even in Kubernetes 

Locustio is a open source load testing tool created in Python. See https://locust.io/ for more information. 
RedHat OpenShift is a enterprise container orchestration tool developed by RedHat based on Kubernetes. 

This repository contains a Dockerfile to allow you to build your locustio Docker container and yaml files to allow you to deploy the container to your OpenShift/Kubernetes cluster. However I have not tested this in Kubernetes so test/hack/edit/deploy at your own leasure/fustration.

Build Instructions
==================
Download the Dockerfile and update according to your own needs.

My attached Docker file keeps things very simple. It is based on the latest python version and uses the latest alpine OS container to keep things small as possible. 
It then installs the required packages to enable locustio to run. 
It then creates a /scripts directory which I mount as a volume so I can inject my test files into my container as a config map. Then I expose just 2 of the default ports I need to run in a headless manner. If you want the GUI enabled then you can add the Web GUI port here. 

Commands to build the container then in your in the same directory as the Dockerfile would be like this:-
```bash
$ docker build --no-cache --label locust=9 -t YourDockerHUbUserName/DockerHubRepo:imagetag .
```
e.g
```bash
$ docker build --no-cache --label locust=9 -t mudasar786/locustio:9 .
```
You should now be able to upload your container to DockerHub:-
```bash
$ docker push YourDockerHUbUserName/DockerHubRepo:imagetag
```
e.g 
```bash
$ docker push mudasar786/locustio:9
```

In a few minutes your container with the correct tags will appear on DockerHub

Deployment Instructions
=======================
You can download all the yaml in this repo and then use the kubectl or the oc client for your cluster to deploy the service to your cluster using the following command:-
```bash
oc create -f service.yaml -f tests-configmap.yaml -f locust-configmap.yaml -f master-job.yaml -f slave-job.yaml
```
This will create for you a headless service in your cluster for your application to use, a OpenShift job for your master and slave pods, 2 config maps, 1 which has the enviroment variables that will be injected into your pods and another config map which includes the test script to use run your load tests. 

The test scripts should be updated to suit your needs. You should refer to the locustio docs for more information on how to do this.