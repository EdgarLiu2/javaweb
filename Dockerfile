FROM tomcat:9

MAINTAINER Edgar

COPY target/javaweb.war /usr/local/tomcat/webapps/javaweb.war


# docker image build -t javaweb-docker:1.0 .
# docker run -d -p 8080:8080 --name javaweb javaweb-docker:1.0
# docker container ls
# docker container logs javaweb
# docker container rm -f javaweb
