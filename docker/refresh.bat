REM mklink /j D:\Documents\liuzhao\workspace\appdata\shares\javaweb D:\Documents\liuzhao\workspace\projects\javaweb
REM REM mklink /j D:\workspace\software\eclipse-jee-photon-R-win32-x86_64\jre D:\workspace\software\jdk1.8.0_181_x64\jre

set ENV=dev
set ENV=qa

docker-compose -p javaweb_%ENV% -f docker\docker-compose.yml -f docker\docker-compose.%ENV%.yml down
call mvn package
REM docker image build -t javaweb-docker:1.3 .
docker-compose -p javaweb_%ENV% -f docker\docker-compose.yml -f docker\docker-compose.%ENV%.yml up -d

docker-compose -p coreit -f docker\docker-compose.coreit.yml down
docker-compose -p coreit -f docker\docker-compose.coreit.yml up -d

REM http://192.168.99.100:8080/javaweb
REM http://192.168.99.100:10080

docker container ls
REM docker container exec -it javaweb%ENV%_web_1 bash
REM docker container exec -it javaweb%ENV%_redis-db_1 bash
REM docker container exec -it coreit_jenkins_1 bash
REM docker container logs javaweb%ENV%_redis-db_1
REM docker image rm -f $(docker image ls -q)