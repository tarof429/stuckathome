# Part 2: Creating an EC2 instance

## Simple Example

I find that the easiest way to get started with Terraform is to use it to create an EC2 instance. This is actually what the Terraform documentation walks you through. As such, I don't think there's a need to repeat what is already being said.

I've created an example at files/ec2_example. Some key differences are:

- I removed the section where a specific version of the aws provider and terraform is specified. I discovered that in doing this, terraform will download the latest version anyways, and this version will be specified in .terraform.lock.hcl (In fact, you don't need to specicy the aws provider. But I suppose this is a good practice.)
- The AMI is for Ubuntu Server 20.04 LTS. I'm not sure what the Hashicorp documentation uses, although if you read down it does say that it refers to an Ubuntu image.

I found that running terraform fmt works as advertised: it formats the .tf file and aligns everything. Don't spend time aligning lines by hand, rely on `terraform fmt`!

It's actually quite easy to create, modify, and delete EC2 instances with Terraform. 

I found that with Terraform, it's easy to change tags without recreating the instance.

Also I found that creating an outputs.tf file is useful so that I don't have to go into the AWS console to find the public IP.

I did not have success using Terraform Cloud. It may have something to do with a typo in main.tf, but as a result I could no longer run `terraform apply` any more. Just to get my code working agaion, I had to delete my EC2 instance manually, delte .terraform and .terraform.lock.hcl, and I also deleted my Terraform Cloud workspace. There doesn't seem to be a way to delete my Terraform Cloud account.

## EC2 creation with user data

Often creating an EC2 instance is not enough. We want to install some packages for example, or set up the hostname so it's memorable. So how do we do this? With user data, of course!

The ec2_better_example directory has an example of creating an EC2 instance and performing post-install actions using user data. Note that this EC2 instance makes use of a security group called *simple_security_group*. This group allows SSH from my local IP. 

## Note about commiting Terraform files to git.

Do not commit .tfstate files. Add them to .gitignore.

## References

https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started