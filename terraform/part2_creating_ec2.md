# Part 2: Creating an EC2 instance

## HelloWorld Example

We start with a simple example that creates an EC2 instance using an AMI. The AMI is for Ubuntu Server 22.04 LTS. 

First cd to the helloworld example.

```
cd files/helloworld
```

If you write teraform files by hand, run terraform fmt to format the file.

```
terraform fmt
```

Next, run terraform init. 

```
cd files/helloworld
terraform init
```

Next, run terraform apply. You'll be prompted to approve the changes.

```
terraform apply
```

Note that AMI IDs are unique to AWS regions. If you get an error saying that the AMI could not be found, validate that the AMI ID exists in the region you want to use.

You can validate the result by logging into the AWS console and going to the EC2 dashboard. Alternatively, run terraform show to see the same values.

Finally, let's destroy the instance. This will terminiate the instance but it may take some time for the instance to be removed.

```
terraform destroy
```


## References

https://livebook.manning.com/book/terraform-in-action