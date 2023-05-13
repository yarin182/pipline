## Build the Jenkins SSH Agent Docker

### Docker Installation

### 1.
Install Docker on the agent machine you want Jenkins to build on

### 2.
After installing, enable the docker API to listen on port 4243 by editing this file

Line 13
```
vim /lib/systemd/system/docker.service
```

Replace the line with

```
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock
```

### Bulid and Push the Jenkins SSH Agent Image

### 1.
In Jenkins Go to Dashboard > Internal, Choose New Item - Pipline

### 2.
Go to the end of the Project under Pipline, under Definition choose Pipline script from SCM

### 3.
under SCM Choose Git

### 4.
Enter the Repository URL and Credentials

### 5. 
In the Git Repository, Insert the public key you want Jenkins to connect via SSH to the Agent Host 

Line 13
```
vim Dockerfile
```
```
JENKINS_AGENT_SSH_PUBKEY {public key}
```

### 6.
Under script path, Choose the pipline script that's on git

### 7.
Click on Build Now,The script will build the SSH Agent image and push it to docker-hub

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
Lables: ssh-agent
Name: ssh-agent
Docker Image: DOCKER-IMAGE tag on DockerHub
Credentials: Add DockerHub Credentials
Container settings -->
Port bindings: 3100:3100
Extra Hosts: host.docker.internal:host-gateway
Remote File System Root: /home/jenkins
Connect method: Connect with SSH
Add SSH Credentials - Add the Private Key you inserted as into the Dockerfile at Bulid and Push the Jenkins SSH Agent Image section step 5 
Host Key Verification Strategy: Non verifying Verification Strategy
Advanced -->
Port: 22
JavaPath: $JAVA_HOME/bin/java
```

Click on save and apply
