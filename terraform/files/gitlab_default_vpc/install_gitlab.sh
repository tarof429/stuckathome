#!/bin/sh

# Install Postfix to send notification emails
sudo yum install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix

# Add the GitLab package repository and install the package
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash

# Install gitlab
yum install -y gitlab-ee

# Browse to the hostname and login. 
# Look for the password in /etc/gitlab/initial_root_password
