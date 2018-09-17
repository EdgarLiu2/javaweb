echo off

IF "%1"=="" GOTO NO_RACK_NAME
set ENV=%1

set APP_VERSION=1.6
set SHARE=D:\liuzhao\workspace\appdata\shares
set SHARE=C:\workspace\shares

mkdir %SHARE%\rancher\data\redis

kubectl apply -f rancher\javaweb.qa.yaml
REM kubectl delete -f javaweb.qa.yaml


REM kubectl exec -it redis-deployment-5569cddfb7-445d6 --namespace=qa1 redis-cli
GOTO EOF


:NO_RACK_NAME
echo Usage: 
echo "    refresh_racher.bat qa1"

:EOF
kubectl get pods --namespace=%ENV%
kubectl get deployment --namespace=%ENV%
kubectl get service --namespace=%ENV%