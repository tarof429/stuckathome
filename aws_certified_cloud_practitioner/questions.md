# Questions

## IAM

- Which IAM entity can be used to delegate permissions: User, Group, Role or Policy? Answer: Role.

- IAM authentication can be federated using either SAML (LDAP) or OIDC like Google. Another option is to use AWS SSO. Cognito can also be used to gain temporary access to AWS. In this case, users are defined in a user pool, and identity pools are used to obtain temporary, limited-privilege credentials. 

- Q: What is a proper definition of an IAM Role? A: An IAM entity that defines a set of permissions for making requests to AWS services, and will be used by an AWS service (failed)

- What is IAM credential report? IAM Credential Report lists all the IAM users in the current acount.

- Q: What are IAM Policies? A: JSON documents that define a set of permissions for making requests to AWS services, and can be used by IAM Users, User Groups, and IAM roles.

- Q: What principle should you apply regarding IAM Permissions? A: Grant least privilege.

- Q: What should you do to increase your root account security? A: Enable Multi-Factor Authentication (MFA)

- Q: IAM User Groups can contain IAM Users and other User Groups A: False: IAM User Groups can contain only IAM Users

- Q: An IAM policy consists of one or more statements. A statement in an IAM Policy consists of the following, EXCEPT A: Version (failed)

- Q: According to the AWS Shared Responsibility Model, which of the following is AWS responsibility? A: AWS Infrastructure

- Q: How can STS help you get some tasks done? A: STS (Security Token Service) lets use assume an IAM role in an AWS Account to gain temporary credentials. It is active by default in all AWS regions.

- Q: You have an EC2 instance that has an attached IAM role providing it with read/write access to the S3 bucket named my-bucket, and it has been successfully tested. Later, you removed the IAM role from the EC2 instance, but after testing you found that writes stopped working but reads are still working. What is the likely cause for this behavior? A: The S3 bucket policy authorizes reads (which you can see by selecting the bucket | Properties)

- Q: You are running an on-premises Microsoft Active Directory to manage your users. You have been tasked to to create another AD in AWS and establishes a trust relationship with your on-premises AD. Which AWS Directory service should you use? A: Use Managed Microsoft AD

-Q: Your AWS account is now growing to 200 IAM users where each user has his own data in an S3 bucket named users-data. For each IAM user, you would like to provide personal space in the S3 bucket with the prefix /home/<username>, where they have read/write access. How can you do this efficiently? A: Create one customer-managed policy with dynamic variables and attach it to a group of all the IAM users

## EC2

- Q: Which EC2 Purchasing Option can provide you the biggest discount, but it is not suitable for critical jobs or databases? A: spot Instances

- Q: What should you use to control traffic in and out of EC2 instances? A: Security Groups

- Q: How long can you reserve an EC2 Reserved Instance? A: 1 or 3 years

- Q: You would like to deploy a High-Performance Computing (HPC) application on EC2 instances. Which EC2 instance type should you choose? A: Compute Optimized

- Q: Which EC2 Purchasing Option should you use for an application you plan to run on a server continuously for 1 year? A: Reserved Instances

- Q: You are preparing to launch an application that will be hosted on a set of EC2 instances. This application needs some software installation and some OS packages need to be updated during the first launch. What is the best way to achieve this when you launch the EC2 instances? A: Write a bash script that installs the required software and updates to your OS, then use this scrip in EC2 User Data when you launch your EC2 instances

- Q: Which EC2 Instance Type should you choose for a critical application that uses an in-memory database? A: Memory Optimized

- Q: You have an e-commerce application with an OLTP database hosted on-premises. This application has popularity which results in its database has thousands of requests per second. You want to migrate the database to an EC2 instance. Which EC2 Instance Type should you choose to handle this high-frequency OLTP database? A: Storage Optimized

- Q: Security Groups can be attached to only one EC2 instance. A: False

- Q: You're planning to migrate on-premises applications to AWS. Your company has strict compliance requirements that require your applications to run on dedicated servers. You also need to use your own server-bound software license to reduce costs. Which EC2 Purchasing Option is suitable for you? A: Dedicated Hosts

- Q: You would like to deploy a database technology on an EC2 instance and the vendor license bills you based on the physical cores and underlying network socket visibility. Which EC2 Purchasing Option allows you to get visibility into them? A:  Dedicated Hosts

- How can you get metadata for an EC2 instance? Answer: At the command prompt in the instance, type ```
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
&& curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/
```.

See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html#instance-metadata-ex-1

- Can you move an EBS volume from one availability zone to another? Answer: No, an EBS volume is created in an availability zone that can't be changed later.

- Where are EBS snapshots created: a region or an availability zone? Answer: a region because it's created in S3.

- Which storage device is physically attached to an EC2 instance: EBS or instance store volume? Answer: Instance store volume (think SSD). Data on an instance store is lost when the instance is powered off. Note: only a few intance types support an instance store volume as the root device.

- How does the Elastic Load Balancer (ELB) assist with fault tolerance? Answer: By distributing connections (think traffic) to multiple back-end instances. 

- Can the Elastic Load Balancer distribute connections across regions? Answer: no, only across availability zones.

- Which type of firewall operates at the instance level? Answer: a security group.

- Which type of public IP address is retained even when the instance is stopped? Answer: An elastic IP address.

- Which of the following is NOT a limitation of scaling vertically? Answer: Requires a load balancer for distributing load

- Which services can scale horizontally? Answer: DynamoDB, EC2 Auto Scaling, S3

- Which pricing model is best suited for a batch computing workload that requires significant compute power and can be stopped at any time? Answer: Spot instances

- Which storage classes are available for the Amazon Elastic File System? Answer: Standard, Infrequent Access Storage (I don't know what storage classes are available)

## S3

- You want to access an s3 bucket from your EC2 instance in a secure fashion. Should you use access keys or roles? Answer: Don't use access keys, as they are stored in plain text on the EC2 instance. Instead, create an IAM role with S3 read only permissions and attach it to the EC2 instance. You do this by first creating the role under IAM, selecting the EC2 instance, going to Security | Modify IAM role, and selecting the role

- What is the most cost-effective storage tier for data that is not often accessed, will be retained for 7 years, and needs to be retrievable within 24 hours? Answer: Amazon S3 Glacier Deep Archive (need to memorize the different glaciers)

- With Amazon S3, which of the following are NOT chargeable items? Answer: Inbound data transfer

- If you have files that you need to store in S3 and you need to have millisecond retrieval times, but don't expect to retrieve them often, what storage class should you use and why? Answer: Use S3 Standard-IA. It is cheaper than S3 Standard, provides millisecond access, and is stored in multiple availibility zones, so it is useful for storing backups. The minimum storage duration is 30 days.

- If you really want to save money storing backups in S3, and you can tolerate retrieval times ranging from minutes to hours (but not days), what storage class should you use? Answer: S3 Glacier.

## StorageGateway

- What is the difference between AWS Storage Gateway and AWS DataSync? Answer: Storage Gateway is meant for data integration. DataSync, on other hand, is meant for data migration. Storage Gateway uses your on-prem data and moves it to AWS.

## Route 53

- Which services does Amazon Route 53 provide: Health checking, DNS, IP routing, domain registration, or content distribution? Answer: health checking, DNS, and domain registration. Note that Route 53 provides several types of health checking.

- In Amazon Route 53, what is the name for the configuration item that holds a collection of records belonging to a domain: DNS record, Alias or Routing Policy? Answer: Hosted zone ???

## Cloudfront 

Need to review.

- You are trying to access a Cloudfront distribution but cannot see the web site. What is a possible cause? Answer: Make sure the default root object is set to index.html.

- What Cloudfront feature allows you to exchange data securely with S3? Answer: Signed URLs.

- What Cloudfront feature allows you to restrict access for multiple files? Answer: Cloudfront Signed cookies

- What feature in Cloudfront allows you to restrict access to a select number of countries? Answer: Cloudfront Geo Restriction

- What service has built-in DoS proection: Route 53, Internet Gateway, Cloudfront or AWS Direct Connect? Answer: Cloudfront is a CDN which provides built-in DoS protection. Among these, AWS Direct Connect provides a way to connect on-prem machines to AWS and does not provide DoS protection.

- What types of Origin does Amazon Cloudfront support? Answer: S3 bucket and EC2 instance

- When you're configuring a Cloudfront distribution to use Signed URLs/Cookies, it is recommended to use ............................ signer instead of ................................ signer. Answer: Trusted Key Group (recommended), Trusted signer

## CodeBuild

- Which of the following services combined allow for continuous integration: CodeCommit, CodeBuild, CodeDeploy? CodeCommit and CodeBuild

## RDS

- RDS is an example of what type of database: Online transaction processing (OLTP), Online analytics processing (OLAP), NO-SQL, or Data warehouse? Answer: OLTP

- What AWS service provides OLAP (data warehousing)? Answer: Amazon Redshift (how to remember this?)

- Which AWS database service offers seamless horizontal scaling: Amazon RDS, Amazon RedShift, Amazon DynamoDB, or Database on Amazon EC2? Answer: Amazon DynamoDB (how to remember this?)

- How can fault tolerance (failover) be added to an Amazon RDS database: By using read replicas, using multi-AZ, using global replicas or using EBS snapshots? Answer: By using Multi-AZ (how to remember this?)

- Why might an organization decide to move an on-premises database to Amazon RDS? Answer: to reduce operational overhead.

- How do you increase the capacity of an Amazon RDS database? Answer: changing to a larger instance type

- A company wants to improve their RDS performance and decrease latency by using an AWS DB caching service. Which of the following would you recommend they use? Answer: ElastiCache, which provides in-memory caching (it is essentially Redis)

- Which service can be used to migrate an on-premises database to Amazon RDS? Answer: AWS Database Migration Service

## Lambda

- If you want to implement serverless cron jobs in AWS, would you use Lambda or S3? Answer: Lambda.

## DynamoDB

- How can an organization enable microsecond latency for a DynamoDB database: Use Amazon ElastiCache, Using DynamoDB Auto Scaling, using read replicas, or using DynamoDB Accelerator (DAX)? Answer: DAX

## Aurora

- What is Amazon Aurora? Answer: a MySQL and PostgreSQL-compatabile relational database.

## Redfish

- Which AWS database service is a relational data warehouse: Amazon RedShift, Amazon RDS Aurora, Amazon DynamoDB, or Amazon ElastiCache? Answer: Redshift

## Athena

- Which service can be used to analyze data on Amazon S3 using serverless SQL queries? Amazon Athena, which is a serverless big data analysis tool.

- You have a lot of logs that you want to perform a query on. If you want to use AWS Athena, where should you put your logs? Answer: Put it in an S3 bucket.

## Kinesis

- What is Amazon Kinesis? Answer: A service for analyzing video and data streams in real time.

- If you have lots of video data that you want to process in real-time, what would you use: Amazon Kinesis Streams or Firehose? Answer: It depends. Both are used to do the collection and processing of data in real-time. Streams is the more customizable option and requires that scaling and provision is done manually. Firehose stores the data in other services such as S3, ElasticSearch, etc.

## DataPipeline
- A company *moves* data between Amazon S3, RDS, DynamoDB and EMR. Which service can help to process and move data between services? Answer: Amazon DataPipeline

## Quicksight

- A company needs an interactive dashboard for business intelligence. What should they use? Amazon QuickSight

## Glue

- A company needs to run ETL jobs on data stored in S3. They are looking for a simple, scalable, and serverless data integration platform. Which service should they use? Answer: AWS Glue

## Neptune

- A company is looking for a fully managed graph database service on AWS. What do you recommend? Answer: Amazon Neptune

## Organizations

- AWS Organizations: You use AWS Organizations to manage multiple AWS accounts. You can group accounts into Organizational Units (OUs) like Development and Production. Each organization can be associated with Service Control Policies (SCPs). 

## ControlTower

- Q: What is ControlTower? A: A service to set up and govern a secure, compliant multi-account environment. It does this by simplifying the process of creating multi-account environments, setting up a landing zone for each user, and uses AWS Organizations to help with ongoing account account management and governance. Control Tower does not manage AWS resources such as EC2, S3, and RDS. That's the purpose of SystemsManager.

- In regards to AWS Control Tower, the following is NOT true: AWS Control Tower does NOT manage  AWS resources such as EC2, S3, and RDS. Control Tower is for user accounts. AWS Systems Manager does.

## SystemsManager

- Systems Manager is a service to gain operation insight and take action on AWS resources such as S3, EC2, etc. It features something called Session Manager, for example, to securely manage remote resources without using SSH. SystemsManager does not manage the Service Catalog.

## TrustedAdvisor

- AWS TrustedAdvisor does NOT provide advice on which of the following: Cost optimization, Performance, TCO, Security, Fault Tolerance. Answer: TCO (why?)

## Personal HealthDashboard

- A company wishes to determine if there will be any AWS maintenance that could affect their systems over the next few days. Which service should they check: AWS Service health dashboard, AWS personal health dashboard, AWS trusted advisor. Answer: Personal health dashboard. The personal health dashboard provides a personalized view of events that could affect your systems. Service health on the other hand is about services.

- A company wishes to restrict the applications users can launch to an approved list. Which service should they use: AWS Service Catalog, AWS Systems Manager, AWS OpsWorks. Answer: AWS Service Catalog. This service can be used to provide an approved catalog of services and applications that users can launch.

## AWS Organizations

- Which of the following is true about AWS Organizations? Using AWS Organizations you can: Programmatically creating new AWS accounts. AWS Organzations manages user accounts and this provides APIs as well as CLI access.

## AWS Artifact

- Which tool can be used to find compliance information that relates to the AWS Cloud platform? Answer: AWS Artifact

- Which service can be used to find reports on Payment Card Industry (PCI) compliance of the AWS cloud? Answer: AWS Artifact

## Pen Tests

- What is AWS' policy regarding penetration testing? Answer: You can now perform penetration testing against several services without approval

## AWS WAF

- Which service can assist with protecting against common web-based exploits? Answer: AWS WAF

- In case of account compromise, which of the following actions should you perform? Answer: Open a support case with AWS

## CloudHSM

- Which service uses a hardware security module to protect encryption keys in the cloud? Answer: AWS CloudHSM

## CloudTrail

- Which service can be used to record information about API activity in your AWS account? Answer: Cloudtrail

- Does Amazon CloudTrail permanently record all API activity in your account by default? Answer: no

## AWS Billng

- Which architectural benefit of the AWS Cloud assists with lowering operational cost? Answer: Higher-level managed services (like S3, RDS, Athena).

- What is the best tool for an organization to compare the cost of running on-premises to using the AWS Cloud? Answer: TCO Calculator (there is such a tool?)

- Which AWS support plan comes with a Technical Account Manager (TAM) Answer: Enterprise

- Which of the following needs to be considered in a Total Cost of Ownership (TCO) analysis? Answer: Data center operations costs.

- Which AWS pricing feature can be used to take advantage of volume pricing discounts across multiple accounts? Answer: Consolidated billing.

- Which tool can an IT manager use to forecast costs over the next 3 months? Answer: AWS Cost Explorer.

- What is AWS Cost Explorer? It is a tool to visualize, understand, and manage your AWS costs and usage over time.

## AWS Snowmobile

- Which service can be used to migrate exabytes of data into the AWS Cloud? Answer: AWS Snowmobile

## AWS Snowball

- Which service can be used to quickly and affordably migrate 50TB of data to Amazon S3 for a company with a slow Internet connection? Answer: AWS Snowball

## AWS Snowcone

- A company is collecting weather data to send to AWS for analytics. Each collection cycle the data doesn’t exceed 7 TB. Which AWS Snow Family product would you recommend? Answer: Amazon Snowcone

## AWS Database Migration Service

- How can a company migrate a database from Amazon EC2 to RDS without downtime? Answer: Migrate using AWS Database Migration Service

## AWS DataSync
- A company needs to migrate several TB of data from an on-premises NAS device to Amazon FSx. Which service can the company use to migrate the data over a VPN connection? Answer: AWS DataSync

## AWS Transcribe

- A company recorded some support call conversations in mp4 files. How can the company extract the audio into a text document? Answer: AWS Transcribe

## AWS Rekognition

- An application is being built that needs to identify faces in images. Which service can be used? Answer: AWS Rekognition

## AWS Translate

- A company is looking to use machine learning to translate a few documents from English to Chinese. Having learned about machine learning services on AWS, which of the following services would you recommend the company to use? Answer: AWS Translate

## Amazon Lex

- A company is planning on implementing a chatbot into their web application. Which AWS service would best meet their needs? Answer: Amazon Lex

## AWS SageMaker
- A company wants to develop their own machine learning application on AWS. Which of the following services would best fit their needs? Answer: Amazon SageMaker

## AWS Polly

- Which of the following services offers Text-to-Speech (TTS) services? Answer: Amazon Polly

## AWS Fargate

- True or false: If you want to deploy containers in AWS, usng serverless solutions like ECS with Fargate is always the best solution. Answer: Using fargate is a good solution if you don't want to manage things like security that's needed with EC2 instances. However, EC2 may be a better solution if you need certain features that are only available with an instance such as machine learning. Also Fargate does not allow you to customize the networking layer.

## AWS EKS

- If you want to deploy containers but don't want to manage servers, and you need certain advanced features such as machine learning, is there any reason not to use EKS? Answer: Using EKS requires expert knowledge of Kubernetes. It can also cost a lot more.

## Lightsail

- What is Lightsail? Answer: It's an easy-to-use virtual private server (VPS) provider that makes it easy to build an application or website.

## Elastic Beanstalk

A key point in understanding Elastic Beanstalk is knowing the deployment options.


### References

https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.rolling-version-deploy.html

### Beanstalk Deployment Options

- AllAtOnce: Deploys to all instances simultaneously

- Rolling - Update a few instances (bucket) at a time

- RollingWithAdditionalBatch: Launches an extra batch of instances, before starting the deployment, to maintain full capacity.

- Immutable: spins up new instances in a new ASG, deploys the application to it, then swaps all the instances when they are healthy

- TrafficSplitting:  Performs traffic-splitting deployments to canary-test your application deployments.

### Quiz

Score (8 of 17 correct)

- Q: You're developing an application and would like to deploy it to Elastic Beanstalk with minimal cost. You should run it in a) Single Instance Mode b) High Availability Mode A: Single Instance Mode

- Q: Elastic Beanstalk application versions can be deployed to a) one environment b) many environments A: Many enviornments (wrong, but why?)

- Q: You have been tasked to run an application developed using Rust language on Elastic Beanstalk. After checking, you found that Rust runtime is not currently supported on Elastic Beanstalk. Which of the following is NOT a solution? A: Install scripts and security software using an EC2 User Data script (wrong)

- Q: Environments in Elastic Beanstalk must have the following names: dev, test, and prod. A: False

- Q: You are developing a new application that's hosted on Elastic Beanstalk. As you are in the development process you don't mind downtime so you want your application to be deployed as soon as a new version is available. Which Elastic Beanstalk deployment option should you use? A: All at Once (wrong)

- Q: A company hosting their website on AWS Elastic Beanstalk. They want a methodology to continuously release new application versions with the ability to roll back very quickly in case if there're any issues. Also, the application must be running at full capacity while releasing new versions. Which Elastic Beanstalk deployment option do you recommend? A: Immutable (wrong but why?)

- Q: You're a DevOps engineer working for a startup company hosting their application on Elastic Beanstalk. The application is in its early phases and it has a lot of new updates every week while being used by a number of users. You want to continuously release new features without application downtime and without incurring extra costs. It's acceptable to temporarily decrease the number of running instances serving users. Which Elastic Beanstalk deployment option should you choose? A: Rolling (wrong)

- Q: Which Elastic Beanstalk deployment option allows you to release new versions of your application with minimal added cost while maintaining the full capacity to serve the current users? A: RollingWithAdditionalBatch (wrong)

- Q: To improve your application performance, you want to add an ElastiCache cluster to your apwplication hosted on Elastic Beanstalk. What should you do? A: Create an elasticache.config file in the .extensions folder in the root of the code zip file and provide appropriate configuration

- Q: Your deployments on Elastic Beanstalk have been painfully slow. After checking the logs, you realize that this is due to the fact that your application dependencies are resolved on each instance each time you deploy. What can you do to speed up the deployment process with minimal impact? A: Resolve the dependencies beforehand and package them in the zip file

- Q: What AWS service does Elastic Beanstakc use under the hood? A: AWS CloudFormation

- Q: Due to compliance regulations, you have been tasked to enable HTTPS for your application hosted on Elastic Beanstalk. This allows in-flight encryption between your clients and web servers. What must be done to set up HTTPS on Elastic Beanstalk? A: Create an .ebextension/securelistener-alb.config file configure the Application Load Balancer

- Q: Which feature in Elastic Beanstalk allows you to automate deletions of old application versions so that new application versions can be created? A: Use a Lifecycle Policy

- Q: You're using Elastic Beanstalk and you would like to schedule tasks to run periodically and asynchronously. These tasks typically take more than 1 hour to complete. Which Elastic Beanstalk environment should you choose? A: Worker environment and cron.yaml file

- Q: You have created a test environment in Elastic Beanstalk and as part of the environment, you have created an RDS DB instance. How can you make sure the database can be used after you delete the environment? A: Make a snapshot of the RDS DB instance before it gets deleted

- Q: You're running an application on Elastic Beanstalk. You have just finished a major update to your application. You want to deploy the new version then direct a small percentage of traffic to the new version so you can test and fall back if there're any issues. Which Elastic Beanstalk deployment option should you choose? A: Traffic Splitting (wrong)

- Q: You have been hired by a company to run some tests on their application hosted on Elastic Beanstalk. You can't run these tests on the current environment as this is the production environment, so you have to create another environment similar to the one already running. Which Elastic Beanstalk feature allows you to do this? A: Elastic Beanstalk Cloning




