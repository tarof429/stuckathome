# Gilab Sample

## Introduction
The Gitlab sample project at `files/gitlab_sample` is a Terraform'ed method of installing GitLab on AWS. It is the recommended method for getting started with GitLab. As such, it does have some limitations:

- The EC2 instance is deployed to the default VPC.
- It does use external services such as databases.

## Pre-requisites
Terraform state is stored in Terraform; see `files/terraform_state_bucket`.

## References
https://about.gitlab.com/install/
