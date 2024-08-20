# Installing Jenkins

## Introduction

In this section, we will install Jenkins on an EC2 instance set up using Terraform.

## Guidelines

The fastest way to install Jenkins is to create an EC2 instance and then go to https://www.jenkins.io/doc/book/installing/linux/ to get the official steps for installing Jenkins.

Some things to note:

- The key_name in jenkins/main.tf needs to match the key name in AWS. Otherwise your instance will not be associated with a keypair and you will not be able to login.
- Jenkins uses port 8080 by default. In order to access Jenkins remotely, we need to create a security group that allows port 8080.
- Ideally, you would also attach an elastic IP to your Jenkins instance so that the IP is fixed.
- The EC2 instance needs to specify the security group by ID, not name. This is because we are specifying a subnet. See https://stackoverflow.com/questions/31569910/terraform-throws-groupname-cannot-be-used-with-the-parameter-subnet-or-vpc-se

## Code Walkthrough

See files/jenkins_basic for a basic example that uses the default VPC.

See files/jenkins_complex for an example that creates a VPC to deploy the EC2 instance running Jenkins. Also it creates an EIP so that the IP to Jenkins persists after reboots. 

## References
- https://medium.com/@navidehbaghaifar/how-to-install-jenkins-on-an-ec2-with-terraform-d5e9ed3cdcd9