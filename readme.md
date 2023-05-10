## Building the Jenkins Slave Docker

### Buliding the Jenkins-SSH-Slave Image through the Jenkins Pipline

### 1. In Jenkins Go to Dashboard > Internal, Choose New Item - Pipline

### 2. Go to the end of the Project under Pipline, under Definition choose Pipline script from SCM

### 3. under SCM Choose Git

### 4. Enter the Repository URL and Credentials

### 5. Under script path, Choose the pipline script that's on git

### 6. The script will build the SSH-Slave image and push it to docker-hub
