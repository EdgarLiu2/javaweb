REM mklink /j D:\Documents\liuzhao\workspace\appdata\shares\javaweb D:\Documents\liuzhao\workspace\projects\javaweb

set ENV=dev
set ENV=qa

docker-compose -p javaweb_%ENV% -f docker-compose.yml -f docker-compose.%ENV%.yml down
call mvn package
REM docker image build -t javaweb-docker:1.3 .
docker-compose -p javaweb_%ENV% -f docker-compose.yml -f docker-compose.%ENV%.yml up -d


REM docker container exec -it javaweb%ENV%_web_1 bash
REM docker container exec -it javaweb%ENV%_redis-db_1 bash
REM docker container logs javaweb%ENV%_redis-db_1

