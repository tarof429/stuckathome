# Setup

## Installation

This section is roughly based on the Udemy course listed in the references. Instead of a docker image, we use a KVM running AlmaLinux 9 (which we renamed `jenkins` and follow the official steps to run Jenkins on AlmaLinux.

Note: install wget first.

To simplify remote access, the firewall was stopped and disabled on the VM.

```sh
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```

AlmaLinux 9 seems to have issues with console login by default. You can use virt-viewer to login through the console, which can be handy if you don't know the IP of the VM.

```sh
sudo virt-viewer --connect qemu:///system --wait jenkins
```

## Post-install Setup

Once Jenkins is running, you'll want to install some additional programs in the VM.

- Install tar, git, java-17-opendjk-devel packages

- Download Apache Maven from https://maven.apache.org/download.cgi and untar it under /usr/local

- configure Jenkins tools to point to Maven, Java (set JAVA_HOME to `/usr/lib/jvm/java`)

## Creating Pipelines

1. Per the instuctions for the Jenkins tutorial at `https://www.jenkins.io/doc/tutorials/build-a-java-app-with-maven/`, fork `https://github.com/jenkins-docs/simple-java-maven-app`. 

2. Create a new pipeline job and call it `simple-java-maven-app`.

3. Scroll down to pipeline, select `Pipeline`, and copy and paste the code in `files/Jenkinsfile_example1`.

## Troubleshooting

If you click on a job and select Replay, you can edit the last pipeline script. This can be handy to troubleshoot build issues without making the change to a pipeline script in git.

## References

- https://www.udemy.com/course/jenkins-masterclass

- https://www.jenkins.io/doc/book/installing/linux/#red-hat-centos

- https://www.jenkins.io/doc/book/pipeline/syntax/

- https://www.jenkins.io/doc/pipeline/steps/workflow-basic-steps/
