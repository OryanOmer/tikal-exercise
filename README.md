# Tikal DevOps Exercise
This GitHub repo contains simple CI flow of opensource project named pyDash, a simple system monitoring dashboard written in Python and using Django as web framework.
<br/>This automation using Vagrant and VirtualBox as virtualization platform, Ansible as configuration management tool, Jenkins as CI/CD platform and Docker.

## Requirements
- VirtualBox
- Vagrant
- At least 4GB of memory on physical host
- Dual core (or better) CPU on physical host
- Access to the internet

## Installation Guide
1. Clone or download this repo:
```
git clone https://github.com/roeizavida/tikal-exercise.git
```

2. cd to directory:
```
cd tikal-exercise/
```

3. Create and provision Vagrant VMs:
```
vagrant up
```

4. After Vagrant done deploying, ssh to machine and copy the ansible directory to local filesystem (ssh username and password is 'vagrant'):
```
ssh vagrant@192.168.1.21
cp -r /vagrant/ansible /tmp/
```

5. cd to ansible directory and run deployment playbook (installs Docker and Jenkins on host):
```
cd /tmp/ansible
ansible-playbook -i inventory install.yml
```

6. After ansible playbook succeeded, Verify that Jenkins is accessible from browser.
   <br/> The url is http://192.168.1.21:8080.

## Jenkins initial setup
1. You need the Jenkins initial password to login to the UI, you can find it on the master server:
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

2. Jenkins initial setup is needed, select 'Install suggested plugins' and let Jenkins download everything.

3. Create admin user for Jenkins, fill in the deatils and go to the next step.

4. Verify that Jenkins URL is the one you accessed earlier and click 'Save and Finish'.

5. Click 'Start using Jenkins' and the Jenkins dashboard will appear.

## Create Jenkins pipeline
1. In Jenkins main page select 'New' -> 'Pipeline' and enter name for the pipeline.

2. In 'Pipeline' tab change the 'Definition' to 'Pipeline script from SCM'.

3. Change 'SCM' to 'Git' and enter 'Repository URL' (https://github.com/roeizavida/tikal-exercise.git).

4. In 'Script Path', verify that the value is 'Jenkinsfile'.

5. Save the pipeline.

## Create DockerHub credential
1. In Jenkins main page select 'Credentials'.

2. In 'Stores scoped to Jenkins' select 'global'.

3. Click 'Add Credentials' and fill in the details:
<br/>'Username' and 'Password' is your DockerHub username and password.
<br/>Set 'ID' and 'Description' as 'dockerhub'.

## Run Jenkins pipeline
1. In Jenkins main page select the pipeline you created earlier and click 'Build Now'.

2. Wait for the pipeline to finish building, it will do the following:
<br/>- Pull the latest code from GitHub.
<br/>- Build docker image from Dockerfile (Containerized version of pyDash).
<br/>- Run container from the pyDash image.
<br/>- Run HTTP healthcheck to verify that the app is running.
<br/>- Stop and remove the container if test was successfull.
<br/>- Tag the image as latest and push to DockerHub.

## Run pyDash container
1. After building the image and pushing to DockerHub, we can run the container from any Docker host by running:
```
docker run -d --name pydash -p 8000:8000 roeizavida/pydash
```

2. We can access the app by browsing to http://192.168.1.21:8000 (username is 'admin' and password is 'password').

3. pyDash will provide dashboard with information about system resources of the container itself.
