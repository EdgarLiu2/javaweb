echo off

IF "%1"=="" GOTO NO_RACK_NAME
set ENV=%1

set APP_VERSION=1.7
set SHARE=D:\liuzhao\workspace\appdata\shares
set SHARE=C:\workspace\shares\rancher\data

mkdir %SHARE%\redis
mkdir %SHARE%\tomcat
mkdir %SHARE%\nginx


IF /I "%ENV%"=="build" (
	set DOCKER_HOST=tcp://192.168.99.101:2376
	set DOCKER_MACHINE_NAME=worker1
	set DOCKER_TLS_VERIFY=1
	set DOCKER_CERT_PATH=C:\Users\liuedg\.docker\machine\machines\worker1
	
	mvn package -f ..\pom.xml
	docker image ls
)
IF /I "%ENV%"=="dev" (
	kubectl delete -f rancher\javaweb.dev.yaml
	kubectl delete configmap nginx-dev-config --namespace=%ENV%
	timeout 30
	copy config\nginx\nginx.rancher.dev.conf nginx.conf
	kubectl create configmap nginx-dev-config --namespace=%ENV% --from-file=nginx.conf
	del nginx.conf
	kubectl create -f rancher\javaweb.dev.yaml
	REM kubectl apply -f rancher\javaweb.dev.yaml

	
	REM kubectl describe pods redis-pod --namespace=dev
	REM kubectl describe pods nginx-pod --namespace=dev
	REM kubectl exec -it tomcat-pod --namespace=dev /bin/bash
	REM kubectl exec -it nginx-pod --namespace=dev /bin/bash
		REM curl http://localhost:8080/javaweb/index.jsp?actor=abc@123.com
		REM curl http://192.168.99.101:30080/javaweb/index.jsp?actor=abc@123.com
		REM curl http://192.168.99.101:30180/javaweb/index.jsp?actor=abc@123.com
)
IF /I "%ENV%"=="qa1" (
	kubectl apply -f rancher\javaweb.redis.qa.yaml -f rancher\javaweb.tomcat.qa.yaml
	REM kubectl delete -f javaweb.qa.yaml
)


REM kubectl exec -it redis-deployment-5c6d7d78b-z9w4c --namespace=qa1 /bin/bash
REM kubectl exec -it tomcat-deployment-75b7496d56-7l77d --namespace=qa1 /bin/bash
REM kubectl exec -it redis-deployment-5569cddfb7-445d6 --namespace=qa1 redis-cli
REM kubectl logs tomcat-deployment-75b7496d56-7l77d

GOTO EOF


:NO_RACK_NAME
echo Usage: 
echo "    refresh_racher.bat build/dev/qa1"

:EOF
kubectl get pods --namespace=%ENV% --output=wide
kubectl get deployment --namespace=%ENV%
kubectl get service --namespace=%ENV%