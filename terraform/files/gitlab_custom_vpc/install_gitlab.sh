#!/bin/sh

# See https://packages.gitlab.com/gitlab/gitlab-ce/install#bash-rpm
# Also https://about.gitlab.com/install/#amazonlinux-2023

# Update all packages
# dnf -y update

# Install Postfix to send notification emails
#dnf install -y postfix
#systemctl enable postfix
#systemctl start postfix

# Add the GitLab package repository and install the package
# curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash

# Install gitlab
# dnf install -y gitlab-ce

# Configure gitlab. 
# See https://docs.gitlab.com/omnibus/settings/configuration.html#configure-the-external-url-for-gitlab
# sudo EXTERNAL_URL="https://gitlab.example.com" dnf install -y gitlab-ce

# Browse to the hostname and login. 
# Look for the password in /etc/gitlab/initial_root_password
