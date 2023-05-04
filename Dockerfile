FROM alpine/alpine:latest

USER root

RUN apk add --no-cache bash sudo wget curl vim openssl ca-certificates iputils zip unzip gnupg 

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

ENV HOME /var/lib/slave
ENV SLAVE_HOME /var/lib/slave
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/

