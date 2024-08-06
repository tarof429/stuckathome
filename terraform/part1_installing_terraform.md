# Part 1: Installing Terraform

Terraform is a CLI for working with AWS. Install the v2 version from AUR: https://aur.archlinux.org/packages/aws-cli-v2-bin. 

Now that Terraform is installed, you need to configure credentials.

1. First login to your AWS account using the web console.

2. Go to IAM | Users, select your user or create a new one (that has Administrator privileges), then select Security credentials tab, and create an access key. Download the CSV file to your local machine.

3. Configure aws. For example:

    ```sh
    aws configure
    AWS Access Key ID [None]: <id>
    AWS Secret Access Key [None]: <key>
    Default region name [None]: us-west-2
    Default output format [None]: json
    ```

Now you can use your credentials in Terraform. To test, try running `aws s3 ls`. 

If you want to use vim with Terraform, see https://github.com/hashivim/vim-terraform. After installation, you can run `:PluginList` from within vim to list loaded plugins. 