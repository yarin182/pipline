## Building the Jenkins Slave Docker

### Buliding the Jenkins-SSH-Slave Image through the Jenkins Pipline

### 1.
In Jenkins Go to Dashboard > Internal, Choose New Item - Pipline

### 2.
Go to the end of the Project under Pipline, under Definition choose Pipline script from SCM

### 3.
under SCM Choose Git

### 4.
Enter the Repository URL and Credentials

### 5.
Under script path, Choose the pipline script that's on git

### 6.
The script will build the SSH-Slave image and push it to docker-hub


### Installing Docker on the agent you want to run the slave on

### 1. Install Docker on the slave machine

### 2. After installing, enable the docker API to listen on port 4243 by editing this file

Line 13
```
vim /lib/systemd/system/docker.service
```

Replace the line with

```
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock
```

### Configure Clouds

### 1.
In Jenkins Go to Manage Jenkins > Nodes, Choose Configure Clouds

### 2.
Choose docker

Docker Configuration

```
Name: Docker
Docker Host URI: tcp://HOST-IP:4243
Enabled: On
Expose DOCKER_HOST: On
```
Docker Agent templates Configuration

```
Lables: slave
Name: slave
Docker Image: DOCKER-IMAGE tag on DockerHub
Credentials: Add DockerHub Credentials
Remote File System Root: /var/lib/slave/
Connect method: Connect with SSH
Add SSH Credentials
Host Key Verification Strategy: Non verifying Verification Strategy
Advanced -->
Port: 22
JavaPath: $JAVA_HOME/bin/java
```

Click on save and apply
