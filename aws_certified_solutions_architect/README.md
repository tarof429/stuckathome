# AWS Certified Cloud Practioner (Topics)

## IAM: AWS Identity and Access Management

To access AWS services, you need to authenticate yourself through IAM. There are several ways to access IAM: 1) console (GUI), 2) using the AWS CLI, and 3) using APIs for automation. The user of IAM is called a principal. A principal may be an acutal person, a role, a federated user, or an application. 

In IAM, there is a root user and a non-root user. When you first sign up with AWS, you will login using the root account using your email address. The root user has full, unrestricted access to AWS services. However, it's a best practice to create an IAM user and login as this user. 

 There are 3 types of policies that can be attached to entities to control access to AWS.

 1. **Identity-based policies**: JSON documents attached to users, groups or roles that control what action they can perform. One form is an an inline policy, which can be applied to any of these but can't be re-used. Managed policies, which may either be AWS managed or customer managed, can be applied to multiple identities like users, groups or roles. 

 2. **Resource-based policies**: These are polices that are attached to resources  like S3 buckets. 
 
 3. **IAM permissions boundaries**: Another type of policy that sets the maximum permissions an identity-based policy can have.

 4. **AWS Organizations service control policies**: Specifies the maximum permissions for an organization.

5. **Session-based policies**: Mainly for APIs and are session based.

The IAM Policy Simulator is a tool to simulate IAM policies. The simulator is located at https://policysim.aws.amazon.com/home/index.jsp?#.

For a list of IAM best practices, see https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html.

If you want to apply permissions to a large number of users, the best practice is to create a group, add permissions to the group, and add users to the group. For example, if I'm in an account called "admins" and you want another person to be an admin, just add the user to that group.

## EC2: Amazon Elastic Compute Cloud

EC2 is one of the original and most important service on AWS. It's also used by many other services in AWS. An EC2 instance is a virtual machine. When you create an EC2 instance, you choose the memory, storage, networking and OS that you want to run in the cloud. AWS then creates the virtual machine for you, and then you're responsible for maintaining the OS. Storage is either Amazon EBS (persistent) or Intance Store (non-persistent). An AMI provides the information required to launch an instance.

### Connecting to EC2 instances

There are a few ways to connect to EC2 instances:

- Using SSH via a key pair (PEM)

- Using RDP (for Windows)

- Using the EC2 console (via EC2 Instance Connect)

- Using your own SSH key and SSH client

If there are any questions on the exam on how you would securely connect to an instance using SSH, choose "key pair".

### EC2 User Data

If you want your instance to run scripts on first boot, you can use User Data. 

### EC2 Metadata

Metadata about the instance is available at http://169.254.169.254/latest/meta-data. It provides information about your intance.

### Accessing services from within EC2 instances

By default, EC2 instances do not have the ability to connect to other AWS services. There are two ways to make this happen:

- Using access keys (which are associated with a user account). This is not secure as the credentials are stored in the EC2 instance and if compromised will expose your credentials.

- Using EC2 Instance profiles (which involves roles)

To use EC2 Instance profiles:

- Go to IAM, select Roles then create a Role with the AmazonS3ReadOnlyAccess policy

- Then go to EC2, select an instance, select Actions | Security and select Modify IAM Role, then choose the role we just created.

Afterwards, you should be able run aws commands from within the instance. For example: *aws s3 ls*.

Now that we've created a role, in the future we can specify this role at the time of EC2 instance creation.

### EC2 Status Checks & Monitoring

AWS will run status checks on each of your EC2 instances and report if any instances cannot be reached. 

AWS also monitors your EC2 instance and reports on metrics such as networking, CPU, memory and disk usage. These metrics come from Cloudwatch. You can go to the Cloudwatch service directly to see metrics for any service that you use. Metrics for EC2 instances are measured per hour. If you want to get even more detail, you can enable detailed metrics for a cost.

### Placement Groups

- Cluster: Instances are created wiithin an availabiltiy zone (possibly in the same rack). This is typically a requirement for HPC deployments. 

- Partition: Multiple instances are deployed to "partitions" or different racks in an availability zone to reduce the likelihood of instance failures. Typically used to deploy Hadoop, Cassandra, Kafka and NoSQL.

- Spread: Similar to Partition but each instance is placed on different hardware and is suitable for critical deployments. This type of deployment can span multiple Availability Zones in the same region.

See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html. 


### Network Interfaces

There are two types of network interfaces: elastic network interfaces and elastic fabric adapters. The Elastic network interface is for general networking needs, while the Elastic Fabric Adapter is suited for HPC. If there are any questions on the exam asking if you should use an Elastic Network Interface (ENI) or an Elastic Fabric Adapter (EFA) for HPC, choose EFA.

When it comes to IP address, there are a few things to consider. Private IPs stay the same no matter the instance state. On the other hand, public IP addresses are dynamic and can change if the instance is stopped. Elastic IP addresses are public IP addresses that are static. They can be assigned to different instances and across availabilty zones. 

### Bastion Hosts

If an EC2 instance only has a private IP, you cannot SSH to it from the Internet. What you need to do is create a bastion host in a public subnet that also has a route to the private subnet. 

### NAT Gateways

If you deploy EC2 instances in a private subnet, you can deploy at NAT gateway so that the instance can connect to the Internet. It's important to remember that such gateways must be deployed to a public subnet. 

In the past, NAT instances were used to route traffic between private subnets and public subnets. These instances use a special AMI with the string "amzn-ami-vpc-nat" in the name. When deploying these AMIs, you need to disable source/destination checks.

NAT instances must be maintained just like any EC2 instance. NAT gateways, on the other hand, are managed by AWS. 

To create a NAT gateway, go to VPC | NAT gateways and create a NAT gateway. Remember that you must choose a public subnet. You must also create an elastic IP. Afterwards, you need to modify edit the route table used by the EC2 instance in the private subnet. Select the route, select Edit routes, and for destination select 0.0.0/0 and target is our NAT gateway. 

### EC2 Instance Lifecycle

EBS-backed intances have an additional instance state called "stopped". You are not stopped for stopped instances.

![Instance Lifecycle](images/instance_lifecycle.png)

See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html.

### EC2 Pricing Options

- On-Demand: EC2 on-demand instances are used for dev/test, are short-term, or have unpredicatable workloads. They are charged the standard rate and have no discount. If there are any questions on the exam about needing short-term or unpredictable workloads, choose "on-demand".

- Reserved: By reserving intances for 1 or 3 years, you get up to a 75% discount. This is a good choice for steady-state, predicatable workloads.

- Spot instances: You get a discount of up to 90% for unused capacity; however, they can be terminated at any time.

- Dedicated instances: The EC2 instance is physically isolated at the host hardware level.

- Dedicated hosts: The physical server is dedicated for you. Ideal if you are using server-bound software licenses. If there are any questions about per-socket licensing, choose dedicated hosts.

### Architecture Patterns for EC2

- If your company needs to run a short batch script to configure EC2 Linux instance after they are launched, add the bash script to the user data of EC2 instances

- If you need a tightly coupled high performance computing (HPC) workload that requires low-latency between nodes and optimum network performance, you should launch EC2 instances in a single AZ in a cluster placement group and use an Elastic Fabric Adapter (EFA)

- If your LoB application receives weekly bursts of traffic and must scale for short periods, and you need the most cost-effective solution for this, use reserved instances for the minimum required workload and then use spot instances for the bursts in traffic.

- If you have an instance that needs a static public IP address, that needs to be remapped to another instance in case of instance failure, attach an elastic IP address to the EC2 instance. Ramap the address as needed.

- You have a fleet of Amazon EC2 instances that run in private subnets across mutlple AZs, then deploy a NAT gateway so that they can reach the Internet.

- If you have an application that uses several EC2 instances, and you want to eliminate the risk of correlated hardware failures, then launch the instances in a spread placement group.

- If your application requires enhanced network capabilities, choose an instance type supports enhanced networking and ensure the ENA module is installed and ENA support is enabled

- If your instance needs close to bare metal performance, EFA, and high performance networking, use an AWS nitro instance type.

### EC2 Questions

1. Q: An organization uses an application that uses per-socket licensing, and they need full control over the placement of their EC2 instances on underlying hardware. What should they use? Answer: Use dedicated hosts

2. Q: Which EC2 pricing model would you use for a short-term requirement that needs to complete over a weekend? A: On-Demand Instance

3. Q: An organization has launched EC2 instances in private subnets. They need to enable Internet connectivity for the subnets. The service should be highly available and scale automatically. What do they need to configure? A: Launch a NAT gateway in a public subnet and add a route in the private subnet route table.

4. Q: Which type of network adapter should be used for High Performance Computing (HPC) uses cases that include tightly coupled applications? A: EFA

5. Q: What can you use to run a script at startup on an Amazon EC2 Linux instance? A: User data

6. Q: What do you need to securely connect using SSH to an EC2 instance launched from the Amazon Linux 2 AMI? A: Key pair

7. Q: An Amazon EC2 instance requires a static public IP address. What would you choose? A: Elastic IP address

8. Q: Which of the following is NOT a benefit of the AWS Nitro System? A: High availability

## Elastic Load Balancer (ELB) and Auto Scaling

To scale the availability of your application, you need to know how to configure auto scaling and how to place an elastic load balancer to distribute traffic to your EC2 instances. 

Scaling up, otherwise known as vertical scaling, means to add or subtract system resources such as CPU, memory and disk. Scaling out, on the other hand, means to add or subtract EC2 instances.

EC2 auto scaling is able to scale in or scale out depending on metrics obtained from Cloudwatch logs indicating CPU usage or instance failure. Below are some key points:

- EC2 auto scaling launches and terminates instances dynamically.

- Scaling is horizontal (scales out)

- Provides elasticity and scalability

- Responds to EC2 status checks and CloudWatch metrics

- Can scale based on demain or on schedule

- Scaling policies define how to respond to changes in demand

- Auto Scaling groups define collections fo EC2 instances that are scaled and managed together.


## AWS Organization and Control Tower

## Amazon Virtual Private Cloud (VPC)

## Amazon Simple Storage Service (S3)

## DNS, Caching and Performance Optimization

## Block and File Storage

## Docker Containers and ECS

## Serverless Applications

## Databases and Analytics

## Deployment and Management

## Monitoring, Logging and Auditing

## Security

## Migration and Transfer

## Web, Mobile, ML and Cost Management
