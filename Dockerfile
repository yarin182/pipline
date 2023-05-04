FROM alpine/alpine:latest

USER root

RUN \
    apk add --no-cache bash sudo wget curl vim openssl ca-certificates iputils zip unzip gnupg && \
    adduser -D slave && \
    addgroup slave wheel && \
    echo "slave:password" | chpasswd && \
    sed -i '/%wheel ALL=(ALL) ALL/s/^# //' /etc/sudoers

COPY ./env_script.sh /usr/local/bin/
COPY ./ct_packandsend /usr/local/bin/

RUN \
    mkdir -p /usr/share/jenkins && \
    chmod +x /usr/local/bin/env_script.sh && \
    chmod +x /usr/local/bin/ct_packandsend && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/usr/share/jenkins/aws.zip" && \
    unzip /usr/share/jenkins/aws.zip -d /usr/share/jenkins/ && \
    /usr/share/jenkins/aws/install

RUN echo "Installing Java-11, this may take a while"

RUN apk add --no-cache openjdk11

RUN \
    wget https://s3.eu-west-1.amazonaws.com/com.communitake.private/jdk-8u371-linux-aarch64.tar.gz -O /usr/lib/jvm/jdk-8u371-linux-aarch64.tar.gz && \
    tar -xvf /usr/lib/jvm/jdk-8u371-linux-aarch64.tar.gz -C /usr/lib/jvm/

RUN echo "Download is complete, Installing Java-8"

RUN \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_371/jre/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_371/bin/javac" 1

RUN echo "Finished installation of Java-8"

RUN \
    mkdir -p /var/lib/slave && \
    chown -R slave:slave /var/lib/slave && \
    chown -R slave:slave $SLAVE_HOME

ENV HOME /var/lib/slave
ENV SLAVE_HOME /var/lib/slave
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/

USER SLAVE
