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

## Helloworld2 example

This next example adds a data section to look up the latest Ubuntu AMI available. Note that in order to run this example, you need to subscribe to Ubuntu 22.04 LTS - Jammy in the AWS Marketplace.

```
cd files/helloworld2
terraform init
terrform apply
```

See https://aws.amazon.com/premiumsupport/knowledge-center/cancel-marketplace-subscription/ for steps on how to unsubscribe to the subscription.


## Hellolocal example

This example writes a file with some content using the local_file resource.

Before we run terraform apply, you can run terraform plan to preview changes. 

If you want to now apply changes without prompting, run:

```
terraform apply -auto-approve
```

If you make a change to the file and run terraform apply again, the file contents will be restored. This is an example of configuration drift and state machine.


However, rather than running terraform apply every time, it is best to run terraform refresh. This allows terraform to reconcile changes made remotely (in this case, in the file) with the .tfstate file.

## References

https://livebook.manning.com/book/terraform-in-action