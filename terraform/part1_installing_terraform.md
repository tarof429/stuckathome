# Part 1: Installing Terraform

Terraform is a CLI which can be installed from the AUR at https://archlinux.org/packages/community/x86_64/terraform/.

After Terraform is installed, you need to configure credentials.

1. First login to your AWS account.

2. Go to IAM | Users, select your user, then select Security credentials tab, and create an access key

3. Confugre aws. For example:

    ```
    aws configure—profile tf-user
    AKIAIOSFODNN7EXAMPLE
    wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    Default region name [None]: us-west-2
    Default output format [None]: json
    ```

Now you can use your credentials in Terraform.
