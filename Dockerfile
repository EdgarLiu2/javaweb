FROM tomcat:9

MAINTAINER Edgar

RUN \
    apt-get update && \
#    apt-get install -y build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY target/javaweb.war /usr/local/tomcat/webapps/javaweb.war


# docker image build -t javaweb-docker:1.3 .
# docker run -d -p 8080:8080 --name javaweb javaweb-docker:1.3
# docker container ls
# docker container logs javaweb
# docker container rm -f javaweb
