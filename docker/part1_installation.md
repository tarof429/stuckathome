# Part 1: Installation

We'll install docker using AWS. The AWS Marketplace has AMIs with docker pre-installed. but we'll forgot that and instead create instances and do the installation ourself.

## Installing Docker on Ubuntu

1. Based on https://aws.amazon.com/marketplace/pp/prodview-cuiyfwsltafu4, we should choose Ubuntu 20.04 LTS with t2.medium.

2. SSH to the instance and run `sudo apt upgrade to update all packages.

3. Reboot

4. Install docker based on the instructions at https://docs.docker.com/engine/install/ubuntu/