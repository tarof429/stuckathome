# Gitlab

## Installation

1. Use the teraform configuration at `teraform/files/gitlab_custom_vpc` to create a minimal EC2 instance.

2. Mount the EBS volume where we will store data. Note that Amazon Linux 2 does not install tools like pvcreate by default. Install the `lvm2` package to install lvm tools. The volume should be mounted at `/var/opt`.

3. Run the script at https://packages.gitlab.com/gitlab/gitlab-ce/install#bash-rpm to install the gitlab package repository.
3. Install gitlab; for example: `sudo EXTERNAL_URL="https://<ip.of.your.instance>" dnf install -y gitlab-ce`. This can take a long time.

## Tips
- Gitlab needs a lot of storage to install. The root disk should be be at least 10G.
- After installation, retrieve the root password at /etc/gitlab/initial_root_password.
- Login as root. As a first step, you might want to disable auto signup. 
- If you make any changes to gitlab configuration, run `sudo gitlab-ctl reconfigure`. 
- You can use pwgen to generate passwords


## References
- https://about.gitlab.com/install/#amazonlinux-2023

- Automating DevOps with GitLab CI/CD Pipelines
