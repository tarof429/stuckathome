# Part 1: Setup

## Introduction

This section covers setting up a CI/CD pipeline with Jenkins, Ansible, and Kubernetes. It is based on the Udemy course: https://www.udemy.com/course/valaxy-devops. 

# Part 1: Setup

## Setting up AWS

1. Setup Jenkins on AWS EC2 instance. To do this, first create the EC2 instance. The course recommends using Amazon Linux. The instance must have a security group rule that allows port 8080 inbound.

2. Next, install Jenkins. You can follow https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS.

3. Edit /etc/hostname, set it to jenkins-server, and restart.

4. Install git: `sudo yum -y update && install -y git`. 

## Setting up a Maven Build Environment

1. Install maven: do a Google search for Maven download and follow the instructions to install Maven on Linux. I like to expand it under /usr/local and then create a soft-link to it.

2. Install Java SDK if you haven't already.

3. Modify /root/.bash_profile and add M2_HOME, M2, JAVA_HOME

4. Install Maven Integration plugin

5. Configure global tool configuration in Jenkins

## Setting up a Gradle Build Environment

1. Download the latest gradle from https://gradle.org/releases/ and scp it to your EC2 instance.

2. Follow the instructions at https://gradle.org/install/ to install it. For example, after unzipping under /opt/gradle, I created a softlink to it called /opt/gradle/latest.

4. Configure global tool configuration in Jenkins

5. Finally, configure a build to use this gradle version.

## Setting up a Tomcat server

1. Create the EC2 instance using Amazon Linux. The instance must have a security group rule that allows port 8080 inbound.

2. Upgrade packages: `sudo yum -y upgrade`

3. Install JDK 11: `sudo amazon-linux-extras install -y java-openjdk11`

4. Download Tomcat from  https://tomcat.apache.org/download-80.cgi and upload it to the instance and extract it to /opt

5. Set execute permissions on some scripts.

    ```
    cd /opt/apache-tomcat-<version>/bin
    chmod +x startup.sh
    chmod +x shutdown.shs
    ```

6. Create a tomcat user and change directory ownership to this user.

8. Create a softlink to tomcat: `ln -s apache-tomcat-8.5.76/ apache-tomcat`

9. Next, create a script to start tomcat (/usr/local/bin/tomcatup): 

    ```
    #!/bin/sh

    export JAVA_HOME=/usr/lib/jvm/jre

    su - tomcat -c  "/opt/apache-tomcat/bin/startup.sh"
    ```

10. Then create a script to stop tomcat (/usr/local/bin/tomcatdown):

    ```
    #!/bin/sh

    export JAVA_HOME=/usr/lib/jvm/jre

    su - tomcat -c  "/opt/apache-tomcat/bin/shutdown.sh"
    ```

11. Next, we should change the Tomcat port to 8090. Edit /opt/apache-tomcat/conf/server.xml and change the value of the connector from 8080 to 8090 and restat tomcat.

12. You need to change your security group too. 

13. Now the application is accessible on port 8090. But Tomcat doesn't allow login from the browser. to fix this, change a default parameter in context.xml.

   ```
   cd /opt/apache-tomcat
   find . -name context.xml
   ```

14. The above command gives three context.xml files. Comment (<!-- & -->) `Value ClassName` field on files which are under the webapp directory. 
Afterwards, restart Tomcat. At the time of this writing, two files will need to be updated.

   ``` 
   /opt/tomcat/webapps/host-manager/META-INF/context.xml
   /opt/tomcat/webapps/manager/META-INF/context.xml
   ```
   
    Afterwards, restart tomcat.

   ```
   tomcatdown  
   tomcatup
   ```

15. Update user information in the tomcat-users.xml file under /opt/apache-tomcat/conf.

   ```
	<role rolename="manager-gui"/>
	<role rolename="manager-script"/>
	<role rolename="manager-jmx"/>
	<role rolename="manager-status"/>
	<user username="admin" password="941kxBqhaC*" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
	<user username="deployer" password="941kxBqhaC*" roles="manager-script"/>
	<user username="tomcat" password="941kxBqhaC*" roles="manager-gui"/>
   ```
16. Restart serivce and try to login to tomcat application from the browser. This time it should be Successful

## Integrating Tomcat with Jenkins

1. Install "Deploy to container" Jenkins plugin and restart Jenkins

2. Next, we need to configure Jenkins so that it can deploy war files to Tomcat. Go to Manage Jenkins | Manage Credentials | Jenkins | global credentials | Add Credentials and add the deployer credential

3. Next, modify the hello-world Jenkins projet and add a post build action to deploy the war to Tomcat. Specify webapp/target/webapp.war, leave the context path empty, and specify a Tomcat 8.x remote container. 

4. Once the job has been rebuilt, go to http://<ip.of.jenkins>:8090/webapp

## Integrating Docker in a CI/CD Pipeline

1. Create a new Amazon Linux EC2 instance

2. First, install yum-cron

   ```
   sudo yum -y install yum-cron
   sudo sysstemctl start yum-cron
   sudo systemctl enable yum-cron
   ```

2. To installl docker run:

   ```
   sudo amazon-linux-extras instal docker
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker ec2-user
   ```

3. Logout and login

4. docker login

## Create a Tomcat container

Although we could use a prebuilt Tomcat container, we'll create it from scratch.

1. SSH to a new instance

2. Download the latest Tomcat 8

   ```
   wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.77/bin/apache-tomcat-8.5.77.tar.gz
   ```

3. Copy all the files in the files directory to your instance.

4. Bulid the container.

   ```
   sh ./build.sh
   ```

5. Run the container

   ```
   sh ./run.sh
   ```

6. To test:

   ```
   curl http://localhost:8090
   ```



