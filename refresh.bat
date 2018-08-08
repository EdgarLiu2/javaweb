
set ENV=qa
set ENV=dev


docker-compose -p javaweb_%ENV% -f docker-compose.yml -f docker-compose.%ENV%.yml down
call mvn package
docker image build -t javaweb-docker:1.3 .
docker-compose -p javaweb_%ENV% -f docker-compose.yml -f docker-compose.%ENV%.yml up -d