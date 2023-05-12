# Exam

## Cloud Concepts

- What is AWS Trusted Advisor? Answer: AWS Trusted Advisor provides real time guidance to help you provision your resource following best practices in the areas of cost optimization, performance, security and fault tolerance. 

- What are the benefits of using AWS cloud? Answer: 1) The ability to experiment quickly and 2) fast provisioning of IT resources 3) ability to go global quickly 4) Scalable compute capacity

- A company is planning to move a number of legacy applications to the AWS Cloud. The solution must be cost-effective. Which approach should the company take? Answer: Rehost the applications on Amazon EC2 instances that are right-sized

- Which on-premises costs must be included in a Total Cost of Ownership (TCO) calculation when comparing against the AWS Cloud? (Select TWO.) Answer: Network infrastructure in the data center and Physical compute hardware. 

- A company plans to move application development to AWS. Which benefits can they achieve when developing and running applications in the AWS Cloud compared to on-premises? (Select TWO.) Answer: AWS makes it easy to implement high availability and AWS can accommodate large changes in applications on demand.

- What is AWS Personal Health Dashboard? Answwer: A service which provides a view into any open issues affecting your infrastructure.

- What can a Cloud Practitioner use the AWS Total Cost of Ownership (TCO) Calculator for? Answer: Estimate savings when comparing the AWS Cloud to an on-premises environment

- What are the benefits of using the AWS Managed Services? (Select TWO.) Answer:  "Alignment with ITIL processes" and  "Baseline integration with ITSM tools" 

- A company plan to move the application development to AWS. Which benefits can they achieve when developing and running applications in the AWS Cloud compared to on-premises? (Select TWO.) Answer: AWS makes it easy to implement high availability and AWS can accommodate large changes in application demand

- What is CloudFormation? An automated way to provision a collection of AWS resources. 

- To reward customers for using their services, what are two ways AWS reduce prices? (Select TWO) Answer: More discount the more services you use and 2) Reduced cost for reserved capacity.

- Which AWS services form the app-facing services of the AWS serverless infrastructure? (Select TWO.) Answer: Amazon API Gateway and AWS Lambda

- What is AWS CodeCommit? Answer: Source Control service that is highly secure, scalable and managed.

## Security and Compliance

- What is AWS Macie? Answer: An AWS service that can be used to discover and protect sensitive data in AWS. It only scans S3 buckets.

- A company must provide access to AWS resources for their employees. Which security practices should they follow? Answer: 1) Enable multi-factor authentication for users and 2) create IAM policies based on least privilege principles.

- What is AWS Shield? Answer: AWS Shield is a service that provides protetion against Denial of Service attacks. 

- What is AWS WAF? Answer: AWS WAF is a web application firewall. It is used to protect web applications from common web exploits that compromise application availibility.

- When should you report to the AWS Trust and Safety Team? Answer: For example, when you notice that an EC2 instance is being used to attempt to flood ports on some of the company’s systems.

-Which of the following a valid best practices for using the AWS Identity and Access Management (IAM) service? (Select TWO.) Answer: Create individual IAM users and Use groups to assign permissions to IAM users

- When do you use Trusted Advisor? Answer: When you need a service to identify if unrestricted access to resources has been allowed by security groups. 

- What is AWS CloudTrail? Answer: A service used for auditing API actions. It can be used to track the activity of users.

- What is AWS CloudHSM? Answer: A cloud-based hardware security module (HSM) that enables you to easily generate and use your own encryption keys on the AWS Cloud.

- A new user is unable to access any AWS services, what is the most likely explanation? Answer: By default new users are created with NO access to any AWS services – they can only login to the AWS console. You must apply permissions to users to allow them to access services.

- What is AWS Inspector? Answer: AWS Inspector is an AWS service which can be used to create an automated security assessment report that will identify unintended network access to Amazon EC2 instances and vulnerabilities on those instances.

- Which of the following can be used to identify a specific user who terminated an Amazon RDS DB instance? Answer AWS CloudTrail, which is used for auditing user actions in AWS. 

- What is Amazon CloudWatch? Answer: Amazon Cloudwatch is a monitoring service which lets you set alarms on services based on some criteria you provide. 

- What is VPC Flow Logs? A feature that enables you to capture information about the IP traffic going to and from network interfaces in your VPC. 

- What is Amazon GuardDuty? A threat detection service

- Which of the following can be assigned to an IAM user? Answer: An access key ID and secret access key and a password for access to the managment console.

- Which feature of AWS IAM enables you to identify unnecessary permissions that have been assigned to users? Answer: Access Adivsor (maybe called Access Analyzer now?)

- Which of the following is NOT a best practice for protecting the root user of an AWS account? Answer: Remove administrative permissions

- our manager has asked you to explain some of the security features available in the AWS cloud. How can you describe the function of Amazon CloudHSM? Answer: It can be used to generate, use and manage encryption keys in the cloud

- Which of the following are NOT features of AWS IAM?  Answer: Logon using local user accounts and Charged for what you use

- Which AWS service or feature can assist with protecting a website that is hosted outside of AWS? 

## Technology

- Will Amazon automatically patch EC2 instances for you? Answer: no, you must do this yourself.

- What is a convertible reserved instance? Answer: An EC2 instance type that offers significant cost savings and whose instance type can be changed. Because it is reserved, it requires a reserveration of at least 1 year.

- If you need an EC2 instance to run software whose license model is tied to the hardware, what instance type should you use? Answer: Amazon EC2 Dedicated Hosts

- What is a dedicated instance? A dedicated instance is an EC2 instance whos hardware will remain the same throughout the lifecycle, but may be shared with other customers.

- What can a Cloud Practitioner use to categorize and track AWS costs by project? Answer: Cost Allocation Tags

- What is AWS Artifact? Answer: AWS Artifact gives users no cost access to AWS security and compliance reports.

- Which of the following tasks can a user perform to optimize Amazon EC2 costs? (Select TWO.) Answer: "Implement Auto Scaling groups to add and remove instances based on demand"  and  "Purchase Amazon EC2 Reserved Instances

- A company requires a dashboard for reporting when using a business intelligence solution. Which AWS service can a Cloud Practitioner use? Answer: Amazon QuickSight

- Which AWS-managed service can be used to process vast amounts of data using a hosted Hadoop framework? Answer: Amazon EMR (Elastic Map Reduce)

- How are Amazon EC2 instances billed, by the hour? Second? Answer: Depends. EC2 instances running Linux or Windows are biled by the second. Others are billed by the hour. Any partial hours are billed as a full hour for these other instance types.

- What is a standard reserved instance? It's an instance type that provides significant savings, but you reserve it for a year and up to 3 years.

- What is Amazon Elastic Transcoder? Answer: A service to convert media files like movies into a format that client devices can use.

- What is AWS Config? A service that enables you to audit your configurations

- What is the Elastic Container Registry? Answer: The AWS managed Docker registry service used by the Amazon Elastic Container Service (ECS)

- Does AWS Elastic Beanstalk provide the fastest way to deploy a popular IT solution so you can start using it immediately? Answer: no, you still need to provide the code. Use AWS Quick Start reference deployments instead; these are Cloud Formation templates.

- What is RDS? Answer: Amazon RDS is a relational database service that is compatible with several database engines, including MySQL. A key benefit is that it simplifies database administration by providing automated backups and automated software patching. RDS provides automated backups by default.

- What is AWS Direct Connect? Answer: AWS Direct Connect is a cloud service that links your network directly to AWS. You bypass the Intenet to delive more consistent, lower-latency performance through increased bandwidth.

- What is AWS Cloudfront? Answer: AWS Cloudfront is a service used to reduce latency and improve transfer speeds. It is designed for static assets like videos, images and files that don't change and can be cached.

- What is Global Accelerator? Answer: A service that finds the optimal route to your services via edge locations.

- When do you use a Virtual Private Network? Answer: - To establish a secure network connection between an on-premises network and AWS

- Which AWS service should a Cloud Practitioner use to establish a secure network connection between an on-premises network and AWS? Answer: Virtual Private Network

- What is a Security Group? Answer; A type of security control used to deny acces from a specific IP address.

- What services does Route 53 provide? Answer: Traffic flow and Domain registration

- What is a Network Access Control List? Answer: A service that provides a firewall at the subnet level within a VPC

- What is an Internet Gateway? A service used to eanble Internet communctions for instances in public subnets

- What are the  primary benefits of using AWS Elastic Load Balancer? Answer: HIgh availability and Elasticity

- What is the relationship between subnets and availability zones? Answer: you can create one or more subnets within each availibility zone.

- What is contained in an Amazxon Virtual Private Coud (VPC)? Answer: Availaiblity zones. After creating a VPC, create a subnet in your VPC and choose an availibility zone for the subnet. VPCs with multiple subnets will have multiple availibility zones.

- How does Amazon S3 store objects? Answer: as key key value pairs.

- Given an S3 bucket policy, what is the element in the policy that needs to be updated to grant a user access to the bucket? Answer: Principal.

- What is AWS Glue? Answer: AWS Glue is a service used to load data from Amazon S3, transform it, and move it to another destination. It is termed "serverless data integration service".

- An application stores images which will be retrieved infrequently, but must be available for retrieval immediately. Which is the most cost-effective storage option that meets these requirements? Answer: Amazon S3 Standard-Infrequent Access

- What is AWS Snowball? Answer: A service used to migrate lots of data from on-premises to the cloud. The network is slow and unreliable.

- What is the AWS Storage Gateway? Answer: A hybrid storage service enables a user’s on-premises applications to seamlessly use AWS Cloud storage

- What are the names of two types of AWS Storage Gateway? (Select TWO.) Answer: File Gateway and Tape Gateway

- What is AWS Athena? Answer: A service can be used to query data in S3 using standard SQL

- What is Amazon Neptune? Amazon Neptune is a graph database service

- What is DynamoDB? A key-value database that scales horizontally.

- What is AWS Snowmobile? Exabyte scale data transfer

- What is S3 Transfer Accleration? Answer: A Service to speed up content transfers to S3 by taking advantage of CloudFront.

- Which type of AWS Storage Gateway can be used to backup data with popular backup software? Answer: Gateway Virtual Tap Library

- Which statement is true in relation to data stored within an AWS Region? Answer: Data is not replicated outside of a region unless you configure it

- Where are Amazon EBS snapshots stored? Answer: On Amazon S3

- How much data can you store on Amazon S3? Answer: Virtually unlimited.

- What types of monitoring can Amazon CloudWatch be used for? Answer: Application performance and operational health, which includes CPU and network utilization

## Billing and Pricing

- What is AWS Organizations? AWS Organizations is a service that gives you the ability to centrally manage multiple AWS accounts. Some benefits include: you wil receive one bill for all accounts in the organization and 2) the unit pricing may be cheaper.

- Which tasks require the use of the AWS account root user? (Select TWO.) Answer: Changing the account name and Changing AWS Support plans

- Which of the statements below is correct in relation to Consolidated Billing? Answer: You receive a single bill for multiple accounts and You can combine usage and share volume pricing discounts

- What is a Technical Account Manager? Answer: A technical account manager is a point of contact who can provide technical support. It comes with Enterprise Support.

- What is AWS Systems Manager? Answer: A service to view operations data.

- Which AWS support plans provide 24x7 access to customer service? Answer: All plans


- Which items are you charged for when using RDS? Answer: Outbound data transfer and multi-AZ.

- A user has an AWS account with a Business-level AWS Support plan and needs assistance with handling a production service disruption. Which action should the user take? Answer: Open a production system down support case" is the correct answer.

- What is AWS Concierge? Answer: a team to support AWS customers on an Enterprise support plan with account issues?

- Does Developer support plan provide phone support? Answer: No, only email. Developer support is the only support plan that provides email only support.

- What do APN Consulting Partners do? Answer: They help organizations design, build and manage workloads on AWS.

- Which support plan is the lowest cost option that allows unlimited cases to be open? Answer: Developer

- Does the Basic suport plan provide email support? Answer: No, this starts from Developer.
