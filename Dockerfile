FROM alpine:latest

USER root

RUN apk add --no-cache bash wget curl ca-certificates zip unzip subversion dos2unix

COPY ./env_script.sh /usr/local/bin/
COPY ./ct_packandsend /usr/local/bin/

RUN \
    mkdir -p /usr/share/jenkins && \
    chmod +x /usr/local/bin/env_script.sh && \
    chmod +x /usr/local/bin/ct_packandsend && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/usr/share/jenkins/aws.zip" && \
    unzip /usr/share/jenkins/aws.zip -d /usr/share/jenkins/ && \
    /usr/share/jenkins/aws/install

RUN echo "Installing Java 11 and 8, this may take a while"

RUN apk add --no-cache openjdk11 openjdk8-jre

RUN echo "Installation is complete"

RUN mkdir -p /var/lib/slave 

RUN echo "Downloading ivy2 dir"

RUN \
    wget https://s3.eu-west-1.amazonaws.com/com.communitake.private/ivy2.tar.gz -O /var/lib/slave/ivy2.tar.gz && \
    tar -xvf /var/lib/slave/ivy2.tar.gz -C /var/lib/slave/ && \
    mv /var/lib/slave/ivy2 /var/lib/slave/.ivy2 

RUN echo "Downloading scripts dir"

RUN \
    wget https://s3.eu-west-1.amazonaws.com/com.communitake.private/scripts_jenkins.tar.gz -O /var/lib/slave/scripts.tar.gz && \
    tar -xvf /var/lib/slave/scripts.tar.gz -C /var/lib/slave/

RUN echo "Downloading mysql-connecter jar"

RUN wget https://s3.eu-west-1.amazonaws.com/com.communitake.private/mysql-connector-java-8.0.25.jar -O /var/lib/slave/mysql-connector-java-8.0.25.jar 

ENV HOME /var/lib/slave
ENV SLAVE_HOME /var/lib/slave
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/

