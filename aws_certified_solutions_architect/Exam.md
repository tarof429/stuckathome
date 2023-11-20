# AWS Certified Cloud Practioner (Exam)

## EC2 Quiz

1. Q: An organization uses an application that uses per-socket licensing, and they need full control over the placement of their EC2 instances on underlying hardware. What should they use? Answer: Use dedicated hosts

2. Q: Which EC2 pricing model would you use for a short-term requirement that needs to complete over a weekend? A: On-Demand Instance

3. Q: An organization has launched EC2 instances in private subnets. They need to enable Internet connectivity for the subnets. The service should be highly available and scale automatically. What do they need to configure? A: Launch a NAT gateway in a public subnet and add a route in the private subnet route table.

4. Q: Which type of network adapter should be used for High Performance Computing (HPC) uses cases that include tightly coupled applications? A: EFA

5. Q: What can you use to run a script at startup on an Amazon EC2 Linux instance? A: User data

6. Q: What do you need to securely connect using SSH to an EC2 instance launched from the Amazon Linux 2 AMI? A: Key pair

7. Q: An Amazon EC2 instance requires a static public IP address. What would you choose? A: Elastic IP address

8. Q: Which of the following is NOT a benefit of the AWS Nitro System? A: High availability

## ELB & ASG Quiz

1. Which type of scaling is provided by Amazon EC2 Auto Scaling? A: Horizontal

2. When using Auto Scaling with Elastic Load Balancing, which type of health checks do AWS recommend you configure? A: EC2 status checks and ELB Health Checks

3. Which of the following listener / protocol combinations is INCORRECT? A: Application Load Balancer TCP and HTTPS/HTTPS

4. Which type of scaling policy should be used to keep the aggregate CPU usage in an ASG at 60%? A: Target tracking policy (failed)

5. An Architect would like to use an Elastic Load Balancer to forward traffic to different back-end applications for https://dctlabs.com/orders and https://dctlabs.com/account. Which type of ELB should be used? A: Application Load balancer with path-based routing

6. Q: Which type of ELB is best suited for use cases that require ultra-low latency TCP connections? A: Network Load Balancer

7. Q: Which type of load balancer would be used in front of virtual appliances such as firewalls, IDS/IPS, and deep packet inspection systems? A: Gateway Load Balancer

## AWS Organization and Control Tower

1. If a company needs to quickly create AWS accounts programatically, what should they do? A: Use AWS Organizations API

2. Q: If users in a member account in AWS Organization need to be restricted from making changes in IAM, what should you do? A: Create a Service Control Policy (SCP) to deny access to IAM actions.

3. Q: How can you move an AWS account between Organizations? A: You can use the Organizations console to migrate accounts.

4. Q: If you created an account through the Organizations console and need to launch resources using that account, what can you do? A: Switch roles to access the new account.

5. If you need to restrict permissions to multiple users using SCPs, what can you do? A: Create an OU and add the users to the OU.

6. If several developers in a company each have their won AWS account for testing and you want to enable central governance, what can you do? A: Create an AWS Organizationa nd send an invite to each developer to join the Organization

## VPC

1. Q: What is the scope of a Virtual Private Cloud (VPC)? A: Regional

2. Q: You need to apply a firewall to a group of EC2 instances launched in multiple subnets. Which option should be used? A: Security Group

3. Q: An attack has been identified from a group of IP addresses. What’s the quickest way to block these specific IP addresses from reaching the instances in your subnets? A: Apply a Network ACL to the subnets involved with a deny rule

4. Q: An organization needs a private, high-bandwidth, low-latency connection to the AWS Cloud in order to establish hybrid cloud configuration with their on-premises cloud. What type of connection should they use? A: AWS DirectConnect

5. Q: You created a new private subnet and created a route table with a path to a NAT gateway. However, EC2 instances launched into this subnet are not able to reach the Internet. Security Groups for the EC2 instances are setup correctly. What is the most likely explanation? A: You need to associate the newe subnet with the new route table

6. Q: How should subnets be used for fault tolerance? A: Create multiple subnets each within a different AZ and launch EC2 instances running your application across these subnets.

7. Q: Your organization has a pre-production VPC and production VPC. You need to be able to setup routing between these VPCs using private IP addresses. How can this be done? A: Configure a peering connection

8. Q: At which level do you attach an Internet gateway? A: VPC

## S3

1. Q: A company is concered about accidental deletion of S3 objects A: Use S3 versioning

2. Q: Data stored in S3 is frequently accessed for 30 days then is rarely accessed but must be immediately accessible A: Use a lifecycle policy to transition objects from S3 standard to Standard-1A after 30 days

3. Q: A backup of S3 objects within a specific folder must be replicated to another region A: Configure cross-region replication and specify the folder name as the prefix <- no

4. Q: Previous versions of objects in a versioning enabled S3 bucket must be stored long term at the lowest cost A: Create a lifecycle rule that transitions previous versions to S3 Glacier Deep Archive 

5. Q: A company wishes to manage all encryption of S3 objects through their application with their own encryption keys A: Use client-side encryption with client managed keys

6. Q: Unencrypted objects in an S3 bucket must be encrypted A: Re-upload the object and specify the encryption 

7. An administrator requires a notification when objects are deleted from S3 A: Configure an event notification that uses the SNS service

8. Q: A group of customers without AWS credentials must be granted time-limited access to ojects A: Use presigned URLs

9. Q: Solution architects require both programmatic and console access across AWS accounts A: Configure cross-account access using IAM rolees


