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
SET SHARE=D:\liuzhao\workspace\appdata\shares
SET SHARE=C:\workspace\shares

mkdir %SHARE%\nginx\logs
mkdir %SHARE%\ssl
mkdir %SHARE%\tomcat\logs
mkdir %SHARE%\redis
mkdir %SHARE%\jenkins\jenkins_home
mkdir %SHARE%\jenkins\docker_cert_path
mkdir %SHARE%\registry\data
mkdir %SHARE%\nexus-data
mkdir %SHARE%\elk\elasticsearch\node1
mkdir %SHARE%\elk\elasticsearch\node2
mkdir %SHARE%\elk\logstash\pipeline
mkdir %SHARE%\elk\filebeat
mkdir %SHARE%\elk\metricbeat

copy /y docker\config\nginx.conf %SHARE%\nginx
copy /y docker\config\javaweb.pipeline.conf  %SHARE%\elk\logstash\pipeline
copy /y docker\config\javaweb.filebeat.yml %SHARE%\elk\filebeat
copy /y docker\config\filebeat.yml %SHARE%\elk\filebeat
copy /y docker\config\metricbeat.yml %SHARE%\elk\metricbeat


IF /I "%RACK_NAME%"=="javaweb" (
	set APP_VERSION=1.6
	set ENV=dev
	set ENV=qa

	docker-compose -p javaweb_%ENV% -f docker\docker-compose.yml -f docker\docker-compose.%ENV%.yml down
	REM call mvn package
	docker-compose -p javaweb_%ENV% -f docker\docker-compose.yml -f docker\docker-compose.%ENV%.yml up -d
	REM docker-compose -p javaweb_%ENV% -f docker\docker-compose.yml -f docker\docker-compose.%ENV%.yml restart nginx
)
IF /I "%RACK_NAME%"=="coreit" (
	docker-compose -p coreit -f docker\docker-compose.coreit.yml down
	docker-compose -p coreit -f docker\docker-compose.coreit.yml up -d --remove-orphans
)
IF /I "%RACK_NAME%"=="elk-qa" (
	docker-compose -p coreit -f docker\docker-compose.elk-qa.yml down
	docker-compose -p coreit -f docker\docker-compose.elk-qa.yml up -d --remove-orphans
	
	REM docker container exec -it coreit_elk-filebeat-2_1 filebeat --strict.perms=false setup -v
	REM docker container exec -it coreit_elk-metricbeat-1_1 metricbeat --strict.perms=false setup -v
)
GOTO EOF


REM http://192.168.99.100:8080/javaweb
REM jenkins:	http://192.168.99.100:8082
REM nexus:		http://192.168.99.100:8081	http://nexus:8081/
REM registry:	http://192.168.99.100:5000/v2/javaweb-docker/tags/list
REM kibana:		http://192.168.99.100:5601
REM elasticsearch:	http://192.168.99.100:9200/_cat/health


REM docker container exec -it javaweb%ENV%_tomcat-1_1 bash
REM docker container exec -it javaweb%ENV%_redis-db_1 bash
REM docker container exec -it coreit_jenkins_1 bash
REM docker container exec -it elk-elasticsearch-2 bash
REM docker container exec -it elk-kibana-1 bash
REM docker container exec -it elk-logstash-1 bash
REM docker container exec -it coreit_elk-filebeat-1_1 bash
REM docker container exec -it coreit_elk-metricbeat-1_1 bash


REM docker container logs javaweb%ENV%_redis-db_1
REM docker container logs javaweb%ENV%_nginx_1
REM docker container logs coreit_nexus_1
REM docker container logs coreit_elk-elasticsearch-1_1
REM docker container logs coreit_elk-elasticsearch-2_1
REM docker container logs coreit_elk-kibana-1_1
REM docker container logs coreit_elk-logstash-1_1
REM docker container logs coreit_elk-filebeat-1_1

REM docker image rm -f $(docker image ls -q)

:NO_RACK_NAME
echo Usage: 
echo "    refresh.bat javaweb|coreit|elk"

:EOF
docker container ls