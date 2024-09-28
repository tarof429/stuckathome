# Part 7: Using Terraform Registry

Terraform has lots of pre-built modules in the [Terraform Registry](https://registry.terraform.io/). Using this website, you can search for any module and learn how to use it. The challenge is figuring out how to use of the sparse documentation.

For example, let's look at the s3 bucket module. If you go to the registry and search for aws s3 bucket, you'll get a result for `terraform-aws-modules/s3-bucket`. The module has a few examples and a link to a list of related modules. It is not very easy to use.

For example, if you create a S3 bucket using the AWS console, there is a section where you can block all public access to the bucket. If you search this page for `public` you'll find a resource called `aws_s3_bucket_public_access_block`. If you click the resource you'll see an example of how to use it. 

If you search for `website` you'll also find a resource called `aws_s3_bucket_website_configuration` that allows you to set up a static website. Buried on this page is some documentation for an output called `website_endpoint`. This is actually the URL to the bucket.

In our example, we want to host a website so we don't want to block public access so we set all the flags in `aws_s3_bucket_public_access_block` to false. 

We also need to create a bucket policy in order to make the website accessible to everyone. The AWS Policy Generator can be used to generate a bucket policy. When using the generator, make sure you append `/*` to the arn so that all the objects in the bucket are affected.

There are two options for using this policy in Terraform. Both of these are documented at `https://developer.hashicorp.com/terraform/tutorials/aws/aws-iam-policy`. One way is to use it as an inline policy. Terraform doesn't recommend this since any changes to the policy won't be detected by Terraform. Instead you should create a `aws_iam_policy_document`. One tricky part of this is defining the resource which in this example is the name of the bucket, plus every thing inside it. Although we could hard-coe the arn, a better way is to use interpolation which is how it is used in the example code.

There is one additional complication when using bucket policies. It needs to be created only after `aws_s3_bucket_public_access_block` has been fully created.  If you run `terraform apply`, you'll get a confusing error saying that the public policies are blocked by the block public access setting. But if you run `terraform apply` again, it will succeed because the public access settings were already created. 

The way to fix this in Terraform is to set the `depends_on` flag in the bucket policy.