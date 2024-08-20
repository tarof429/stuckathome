# State Locking

AWS can be used to store the state file. The advantage to this approach is so that multiple users can collaborate on infrastructure created by Terraform without causing state inconsistencies. It is a little like using git to store Terraform state. 

See the files/state_locking example.

## References

https://medium.com/all-things-devops/how-to-store-terraform-state-on-s3-be9cd0070590