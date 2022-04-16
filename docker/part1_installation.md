# Part 1: Installation

## Running docker on AWS.

The AWS Marketplace has AMIs with docker pre-installed. but we'll forgot that and instead create instances and do the installation ourself. Below are steps to do install docker on an Ubuntu instance.

1.  Create an Ubuntu 20.04 LTS instance with t2.medium.

2. SSH to the instance and run `sudo apt upgrade to update all packages.

3. Reboot

4. Install docker based on the instructions at https://docs.docker.com/engine/install/ubuntu/

## References

https://aws.amazon.com/marketplace/pp/prodview-cuiyfwsltafu4,