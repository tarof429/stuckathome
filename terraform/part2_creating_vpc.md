# Creating a VPC using Terraform

1. Create a file called main.tf within a folder called first-resource.

2. Create a provider for aws. For example:

    ```sh
    provider "aws" {
        region = "us-west-2"
    }
    ```

3. 4. Run terraform init. This will create some files within the folder.

4. Add a VPC resource. It will look something like this:

    ```sh
    resource "aws_vpc" "myvpc" {
        cidr_block = "10.0.0.0/16"
        tags = {
            Name = "myvpc"
        }
    }
    ```

    The name of our VPc is called "myvpc".

5. Now run terraform plan. This will list the resources that terraform will generate.

6. Now run terraform apply to create the resources.

7. If we run terraform show, we can see what resources terraform actually created. You can also go to the AWS console to see the resources.

8. Once satisfied, we can run terraform destroy to destroy the resources.

9. An important concept we need to know is state files. Every time we tell terraform to create, modify or delete resources, the state is store in a state file. Do not lose this state file.