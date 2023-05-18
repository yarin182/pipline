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

## all steps from here can be skipped by running

```
./agent-pre-install.sh
```

### 3.
Create a Jenkins user on the host

```
useradd jenkins
```

### 4.
Install AWS CLI on the host with aws configure

### 5.
grant permissions for the Jenkins user

```
chown -R jenkins:jenkins ~/.aws && chown -R jenkins:jenkins ~/.aws/* && cp ~/.aws /home/jenkins/ && chown -R jenkins:jenkins /var/run/docker.sock
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

Line 81
```
vim Dockerfile
```
Add the {public key} of your choice
```
ENV JENKINS_AGENT_SSH_PUBKEY {public key}
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
Mounts:
type=bind,src=/home/jenkins/.aws/,dst=/home/jenkins/.aws/,bind-propagation=shared
type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock,bind-propagation=shared
type=bind,src=/etc/localtime,dst=/etc/localtime,bind-propagation=shared
Port bindings: 3100:3100
Extra Hosts: host.docker.internal:host-gateway
Remote File System Root: /home/jenkins
Connect method: Connect with SSH
Add SSH Credentials - Add the Private Key you inserted into the Dockerfile at Bulid and Push the Jenkins SSH Agent Image Section step 5 
Host Key Verification Strategy: Non verifying Verification Strategy
Advanced -->
Port: 22
JavaPath: /usr/lib/jvm/java-11-openjdk-amd64/bin/java
```

Click on save and apply

### Build a Project with the SSH Agent

### 1.
In Jenkins, Go to the Project you want to build

### 2.
Open the configuration Panel for you job

### 3.
Under the General section: Check the option ''Restrict where this project can be run''

### 4.
Enter the label name configured in the Docker Agent templates Configuration above Under ''Lables'', in this case the label is ''ssh-agent''

### 5.
Click on save and apply

### 6.
Click on Build Now
