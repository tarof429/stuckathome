# Part 1: Installing Terraform

Terraform is a CLI for working with AWS. It is a standard package on ArchLinux.

To work with Terraform, you'll also need to install awsl-cli. Install the v2 version from AUR: https://aur.archlinux.org/packages/aws-cli-v2-bin. 

Now that Terraform is installed, you need to configure credentials.

1. First login to your AWS account.

2. Go to IAM | Users, select your user, then select Security credentials tab, and create an access key

3. Configure aws. For example:

    ```sh
    aws configure
    AWS Access Key ID [None]: <id>
    AWS Secret Access Key [None]: <key>
    Default region name [None]: us-west-2
    Default output format [None]: json
    ```

Now you can use your credentials in Terraform. To test, try running `aws s3 ls`. 
