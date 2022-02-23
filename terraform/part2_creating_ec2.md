# Part 2: Creating an EC2 instance

I find that the easiest way to get started with Terraform is to use it to create an EC2 instance. This is actually what the Terraform documentation walks you through. As such, I don't think there's a need to repeat what is already being said.

I've created an example at files/ec2_example. Some key differences are:

- I removed the section where a specific version of the aws provider and terraform is specified. I discovered that in doing this, terraform will download the latest version anyways, and this version will be specified in .terraform.lock.hcl (In fact, you don't need to specicy the aws provider. But I suppose this is a good practice.)
- The AMI is for Ubuntu Server 20.04 LTS. I'm not sure what the Hashicorp documentation uses, although if you read down it does say that it refers to an Ubuntu image.

I found that running terraform fmt works as advertised: it formats the .tf file and aligns everything. Don't spend time aligning lines by hand, rely on `terraform fmt`!

It's actually quite easy to create, modify, and delete EC2 instances with Terraform. 

I found that with Terraform, it's easy to change tags without recreating the instance.

Also I found that creating an outputs.tf file is useful so that I don't have to go into the AWS console to find the public IP.

I did not have success using Terraform Cloud. It may have something to do with a typo in main.tf, but as a result I could no longer run `terraform apply` any more. Just to get my code working agaion, I had to delete my EC2 instance manually, delte .terraform and .terraform.lock.hcl, and I also deleted my Terraform Cloud workspace. There doesn't seem to be a way to delete my Terraform Cloud account.

## References

https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started