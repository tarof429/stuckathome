# Setup

## Installation

This project is roughly based on the Udemy course listed in the references. We use KVMs running AlmaLinux 9.

Use the install script.

```sh
sh ./install.sh  -n jenkins-server -i 192.168.1.50
sh ./install.sh  -n jenkins-node -i 192.168.1.55
```

You can SSH to each server as user `jenkins`.

To verify connectivity, run the sshping playbook.

```sh
ansible-playbook sshping.yml
```

## Post-install Setup

Once the servers are running, run the following:

```sh
ansible-playbook update.yml
ansible-playbook setup_server.yml
ansible-playbook setup_node.yml
```

You also need to do the following on both servers:

- Download Apache Maven from https://maven.apache.org/download.cgi and untar it under /usr/local

- configure Jenkins tools to point to Maven, Java (set JAVA_HOME to `/usr/lib/jvm/jre-17-openjdk`)

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
