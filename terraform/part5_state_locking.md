# State Locking

AWS can be used to store the state file. The advantage to this approach is so that multiple users can collaborate on infrastructure created by Terraform without causing state inconsistencies. It is a little like using git to store Terraform state. 

See the `files/state_locking` for a simple example where the S3 bucket is already set up.

In the next example in `files/state_locking2`, we will set up the S3 bucket itself using Terraform. You should become familiar with Terraform's S3 bucket functionality at https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket. 

To deploy this example, first comment out the s3 backend because the bucket does not exist at this point. After the bucket is created, then you can uncomment the s3 backend.

Remember to change the `prevent_destroy` flag in the S3 bucket if you want to really destroy the bucket.


## References

https://medium.com/all-things-devops/how-to-store-terraform-state-on-s3-be9cd0070590