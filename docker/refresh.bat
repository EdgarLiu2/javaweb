echo off
REM mklink /j D:\Documents\liuzhao\workspace\appdata\shares\javaweb D:\Documents\liuzhao\workspace\projects\javaweb
REM mklink /j C:\workspace\shares\javaweb C:\workspace\eclipse\javaweb
REM mklink /j D:\workspace\software\eclipse-jee-photon-R-win32-x86_64\jre D:\workspace\software\jdk1.8.0_181_x64\jre

REM cd C:\workspace\eclipse\javaweb
REM cd D:\liuzhao\workspace\projects\javaweb
REM call ../../setpath.bat

IF "%1"=="" GOTO NO_RACK_NAME
set RACK_NAME=%1

set ELASTIC_VERSION=6.4.0
set APP_VERSION=1.6
SET SHARE=D:\liuzhao\workspace\appdata\shares
SET SHARE=C:\workspace\shares
SET DOCKER_HOME=C:\workspace\Kubernetes\docker

mkdir %SHARE%\nginx\logs
mkdir %SHARE%\tomcat\logs
mkdir %SHARE%\jenkins\jenkins_home
mkdir %SHARE%\jenkins\docker_cert_path
copy /y %DOCKER_HOME%\machine\machines\default\*.pem %SHARE%\jenkins\docker_cert_path\default
copy /y %DOCKER_HOME%\machine\machines\default\id_rsa* %SHARE%\jenkins\docker_cert_path\default


IF /I "%RACK_NAME%"=="web-dev" (	
	docker-compose -p javaweb_dev -f docker\docker-compose.yml -f docker\docker-compose.dev.yml down
	REM call mvn package
	docker-compose -p javaweb_dev -f docker\docker-compose.yml -f docker\docker-compose.dev.yml up -d --remove-orphans
	
	REM docker container exec -it javawebdev_tomcat-1_1 bash
)
IF /I "%RACK_NAME%"=="web-qa1" (
	docker-compose -p javaweb_qa1 -f docker\docker-compose.yml -f docker\docker-compose.qa.yml down
	docker-compose -p javaweb_qa1 -f docker\docker-compose.yml -f docker\docker-compose.qa.yml up -d --remove-orphans

	REM docker container exec -it javawebqa1_tomcat-1_1 bash
	REM docker container exec -it javawebqa1_nginx_1 bash
	REM docker container logs javawebqa1_redis-db_1
	REM docker container logs javawebqa1_nginx_1
)
IF /I "%RACK_NAME%"=="coreit" (
	docker-compose -p coreit -f docker\docker-compose.coreit.yml down
	docker-compose -p coreit -f docker\docker-compose.coreit.yml up -d --remove-orphans
	
	REM docker container exec -it coreit_jenkins_1 bash
	REM docker container logs coreit_nexus_1
)
IF /I "%RACK_NAME%"=="elk-qa" (
	docker-compose -p qa -f docker\docker-compose.elk-qa.yml down
	docker-compose -p qa -f docker\docker-compose.elk-qa.yml up -d --remove-orphans
	
	REM docker container exec -it qa_elk-filebeat-2_1 filebeat --strict.perms=false setup -v
	REM docker container exec -it qa_elk-metricbeat-1_1 metricbeat --strict.perms=false setup -v
	
	REM docker container exec -it qa_elk-elasticsearch-2 bash
	REM docker container exec -it qa_elk-kibana-1 bash
	REM docker container exec -it qa_elk-logstash-1_1 bash
	REM docker container exec -it qa_elk-filebeat-1_1 bash
	REM docker container exec -it qa_elk-metricbeat-1_1 bash

	REM docker container logs qa_elk-elasticsearch-1_1
	REM docker container logs qa_elk-elasticsearch-2_1
	REM docker container logs qa_elk-kibana-1_1
	REM docker container logs qa_elk-logstash-1_1
	REM docker container logs qa_elk-filebeat-1_1
)
IF /I "%RACK_NAME%"=="elk" (
	docker-compose -p coreit -f docker\docker-compose.elk.yml down
	docker-compose -p coreit -f docker\docker-compose.elk.yml up -d --remove-orphans
	
	REM docker container exec -it coreit_elk-filebeat-2_1 filebeat --strict.perms=false setup -v
	REM docker container exec -it coreit_elk-metricbeat-1_1 metricbeat --strict.perms=false setup -v
)
IF /I "%RACK_NAME%"=="stop" (
	docker-compose -p javaweb_dev -f docker\docker-compose.yml -f docker\docker-compose.dev.yml down
	docker-compose -p javaweb_qa1 -f docker\docker-compose.yml -f docker\docker-compose.qa.yml down
	docker-compose -p coreit -f docker\docker-compose.coreit.yml down
	docker-compose -p qa -f docker\docker-compose.elk-qa.yml down
)
GOTO EOF


REM http://192.168.99.100:8080/javaweb
REM jenkins:	http://192.168.99.100:8082
REM nexus:		http://192.168.99.100:8081	http://nexus:8081/
REM registry:	http://192.168.99.100:5000/v2/javaweb-docker/tags/list
REM kibana:		http://192.168.99.100:5601
REM elasticsearch:	http://192.168.99.100:9200/_cat/health






REM docker image rm -f $(docker image ls -q)
REM docker-machine ssh default

:NO_RACK_NAME
echo Usage: 
echo "    refresh.bat web-dev|web-qa1|coreit|elk-qa|elk"

:EOF
docker system prune -f
docker container ls