#!/bin/bash

echo "Installing AWS CLI, this may take a while"

mkdir -p /usr/share/jenkins 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/usr/share/jenkins/aws.zip" 
unzip /usr/share/jenkins/aws.zip -d /usr/share/jenkins/ 
/usr/share/jenkins/aws/install

echo "AWS CLI Installed successfully"

rm -rf /usr/share/jenkins/aws.zip

useradd jenkins

aws configure

chown -R jenkins:jenkins ~/.aws && chown -R jenkins:jenkins ~/.aws/* && cp ~/.aws /home/jenkins/ && chown -R jenkins:jenkins /var/run/docker.sock

