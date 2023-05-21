FROM jenkins/ssh-agent:latest

RUN echo "Installing Packages"

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y sudo bash apt-transport-https software-properties-common wget curl vim dos2unix openssl ca-certificates iputils-ping zip unzip gnupg jq subversion

RUN \
    usermod -aG sudo jenkins && \
    echo "jenkins:password" | chpasswd

RUN echo "Packages Installed successfully"

COPY ./scripts/* /usr/local/bin/
COPY ./scripts/* /home/jenkins/
RUN mkdir -p /var/lib/jenkins

RUN echo "AWS CLI Installed successfully"

RUN echo "Installing Java-11, this may take a while"

RUN apt-get install -y openjdk-11-jdk

RUN echo "Java-11 Installed successfully"

RUN echo "Downloading Java-8"

RUN \
    wget https://s3-eu-west-1.amazonaws.com/com.communitake.private/jdk-8u121-linux-x64.tar.gz -O /usr/lib/jvm/jdk-8u121-linux-x64.tar.gz && \
    tar -xvf /usr/lib/jvm/jdk-8u121-linux-x64.tar.gz -C /usr/lib/jvm/ 

RUN echo "Download is complete, Installing Java-8"

RUN \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_121/jre/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_121/bin/javac" 1

RUN echo "Java-8 Installed successfully"

RUN echo "Downloading ivy2 dir"

RUN \
    wget https://s3.eu-west-1.amazonaws.com/com.communitake.private/ivy2.tar.gz -O /home/jenkins/ivy2.tar.gz && \
    tar -xvf /home/jenkins/ivy2.tar.gz -C /home/jenkins/ && \
    mv /home/jenkins/ivy2 /home/jenkins/.ivy2

RUN echo "Downloading scripts dir"

RUN \
    wget https://s3.eu-west-1.amazonaws.com/com.communitake.private/scripts_jenkins.tar.gz -O /home/jenkins/scripts.tar.gz && \
    tar -xvf /home/jenkins/scripts.tar.gz -C /home/jenkins/

RUN echo "Downloading mysql-connecter jar"

RUN wget https://s3.eu-west-1.amazonaws.com/com.communitake.private/mysql-connector-java-8.0.25.jar -O /var/lib/jenkins/mysql-connector-java-8.0.25.jar

RUN echo "Deleting Unnecessary Files"

RUN rm -rf /usr/lib/jvm/jdk-8u121-linux-x64.tar.gz && rm -rf /home/jenkins/ivy2.tar.gz && rm -rf /home/jenkins/scripts.tar.gz

ENV HOME /home/jenkins
ENV AGENT_HOME /home/jenkins
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
ENV JENKINS_AGENT_SSH_PUBKEY ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAhD7lKrqJwPrttPKlv34IwnU3DPvw6TStvvPifiWpWCcvziy5YhTi9gqUB6h3efTu88pKk7ufJzK1ji83aHq42fz24aWQtt24XC8q7cDB8eVQRvF5s2JieEiG+aWuAEqin8SZhn44f+LW182erDgpR65dZ2V7mDAlGZ6vJWPZ2OGMNbGQanyuh34g+2zMRZ2InOwF231bB2VgR/ud8D2DNapV9nazY7kPkH69EZHdK7r0nGC2IoGQY2Ec4AaqPrKgb7YrKvjoLPmSyriPdbEJwyF3WZFaXrxTBMeJGUqHnw3vVzG6CJM44bgC9RsNuyVbR5tNYcKD2+2kgQ3efGu68Q== agent
ENV TZ Asia/Jerusalem

RUN chown -R jenkins:jenkins /home/jenkins/ && find /home/jenkins/ -depth -exec chown -R jenkins:jenkins {} \;

RUN chown -R jenkins:jenkins /var/lib/jenkins && chown -R jenkins:jenkins /var/lib/jenkins/mysql-connector-java-8.0.25.jar

RUN update-alternatives --set java /usr/lib/jvm/jdk1.8.0_121/jre/bin/java
