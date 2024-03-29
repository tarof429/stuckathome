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


## DNS, Caching, and Performance

1. Q: A company provides videos for new employees around the world. They need to store the videos in one location and then provide low-latency access for the employees around the world. Which service would be best suited to providing fast access to the content? A: Amazon CloudFront

2. Q: An Architect is designing a web application that has points of presence in several regions around the world. The Architect would like to provide automatic routing to the nearest region, with failover possible to other regions. Customers should receive 2 IP addresses for whitelisting. How can this be achieved? A: AWS Global Accelerator provides static IP addresses that act as a fixed entry point to application endpoints in a single or multiple AWS Regions. It uses 2 static anycast IP addresses.

3. Q: Which of the following are NOT valid origins for Amazon CloudFront? A: AWS Lambda is not a valid origin for Amazon CloudFront.

4. Q: An Architect needs to point the domain name dctlabs.com to the DNS name of an Elastic Load Balancer. Which type of record should be used? Q: An Alias record can be used with domain apex records and can point to an ELB.

5. Q: A company hosts copies of the same data in Amazon S3 buckets around the world and needs to ensure that customers connect to the nearest S3 bucket. Which Route 53 routing policy should be used? Q: The latency routing policy directs based on the lowest latency to the AWS resource. Latency increases over distance so this should ensure customers connect to the closest S3 bucket.

6. Q: A media organization offers news in local languages around the world. Which Route 53 routing policy should be used to direct readers to the website with the correct language? A: In this case you need to identify specific geographic locations and associate them with the correct language version.

7. Q: Which routing policy would you use to route to a secondary destination in the event a primary is down? A: Failover routing works based off of health checks and will route to a secondary destination in the event a primary destination is down

8. Q: Which of the following are migration services compatible with Route 53? A: All of these are Route 53 compatible services

## Block and File Storage

1. Q: What is a simple and automted method of backing up Amazon EBS Volumes? A: Use Data Lifecycle Manager and add a schedule

2. Q: What service provides centralized storage and local caching for performance?  A: For the best performance, using instance stores

3. Q: If you need an EC2 instance that starts up quickly and has all application dependencies pre installed, what can you do? A: Create an AMI

4. Q: If you need many Linux instances to attach to a shared filesystem that scales elastically, what do you need? A: Use EFS and mount it in each instance.

5. Q: If you require a managed file system that uses NTFS, what can you use? A: Use Amazon FSx for Windows File Server

6. Q: On-premises servers must be able to attach a block storage system locally. Data should be backed up to S3 as snapshots. A: Deploy a Storage Gateway in stored volume mode

7. Q: An Amazon EBS voume must be moved between regions A: Take a snapshot of the EBS volume and move it to another region

8. Q: Root EBS volumes for a critical application must not be deleted after terminaition A: Modify the delete on termination attribute when launching the EC2 instance

9. Q: On-premises servers use NfS to attach a file system. The file system should be replaced with an AWS service that uses Amazon S3 with a local cache A: Deploy an AWS Storage Gateway file gateway

## Docker Containers and ECS

1. Q: Application will be deployed on Amazon ECS and must scale based on memory A: Use service auto scaling and use the memory utilization

2. Q: Application will run on Amazon ECS tasks across multiple hosts and needs access to an Amazon S3 bucket. A: Use a task execution IAM role to provide permissions to S3 bucket

3. Q: Company requires standard Docker container automation and management service to be used across multiple environments A: Deploy Amazon EKS

4. Q: Company plans to deploy Docker containers on AWS at the lowest cost A: Use Amazon ES with a cluster of Spot instances and enable Spot instance draining.

5. Q: Company plans to migrate Docker containers to AWS and does not want to manage operating systems A: Migrate to Amazon ECS using the Fargate launch type

6. Q: Multiple microservices applications running on Amazon ECS need to route based on information int he HTTP header A: Deploy an Application Load Balancer in front of ECS and use query string parameter based routing

7. Q: Containerized app runs on Amazon EKS. Need to collect and centrally view metrics and logs including EKS namespaces and EKS services A: Configure Cloudwatch Container Insights and view data in CloudWatch console

