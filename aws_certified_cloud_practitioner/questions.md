# Questions

## Cloud Computing

- Q: What are the 6 pillars of of the AWS well-architected framework? A: operational excellence, security, reliability, performance efficiency, cost optimization, and sustainability. See https://aws.amazon.com/architecture/well-architected for detailed explanations of the pillars and labs.

- Q: What are the benefits of using AWS cloud? A: 1) The ability to experiment quickly and 2) fast provisioning of IT resources 3) ability to go global quickly 4) Scalable compute capacity

- Q: A company is planning to move a number of legacy applications to the AWS Cloud. The solution must be cost-effective. Which approach should the company take? A: Rehost the applications on Amazon EC2 instances that are right-sized

- Q: Which on-premises costs must be included in a Total Cost of Ownership (TCO) calculation when comparing against the AWS Cloud? (Select TWO.) A: Network infrastructure in the data center and Physical compute hardware. 

- Q: A company plans to move application development to AWS. Which benefits can they achieve when developing and running applications in the AWS Cloud compared to on-premises? (Select TWO.) Answer: AWS makes it easy to implement high availability (think ASG and Load Balancers) and AWS can accommodate large changes in applications on demand (no need to buy servers or network equipment).

- Q: What are the benefits of using the AWS Managed Services? (Select TWO.) A:  "Alignment with ITIL processes" and  "Baseline integration with ITSM tools" 

- Q: To reward customers for using their services, what are two ways AWS reduce prices? (Select TWO). A: More discount the more services you use and 2) Reduced cost for reserved capacity.

- Q: How does AWS provide access to higher level managed services? A: AWS provides users instant acces to a variety of services such as compute, storage, analytics and deployment. By utilizing these servicves, customers can lower operational complexity and cost.

## IAM

- Q: What is IAM? Answer: IAM is a service that controls who gets access to AWS services, and what they can do with those services.

- Q: Do users have access to all services by default? A: No, users must be explictly given access to services.

- Q: All users must belong to a group, true or false. A: False, groups are optional and give you the ability to apply a set of policies to users easily.

- Q: User Groups can be nested, true or false. A: False, User Groups cannot container other User Groups.

- Q: An IAM Policy can be assigned to users or groups, but not both, true or false. A: False, IAM Policies, which define the set of actions users can perform, can be assigned to both users or groups.

- Q: What is the purpose of an IAM Role? A: An IAM Role is used to delegate permissions to another entity. For example, you can create an IAM Role to allow CloudFormation the ability to create resources on your behalf.

- Q: What is the purpose of access keys? A: Access keys allow programatic access to services.

- Q: What is an SCP? A: An SCP is a Service Control Policy that allows you to define the maximum set of permissions users can have in your organization. It is part of AWS Organizations.

- Q: Give an example of some best practices for IAM. A: Lock the root account. Create an individual IAM users. Grant least privilege. Configure strong passwords and use MFA. Use roles instead of access keys inside EC2 instances. Use IAM roles to delegate permissions. Don't share access keys. Rotate passwords regularly.

- Q: A company must provide access to AWS resources for their employees. Which security practices should they follow? A: 1) Enable multi-factor authentication for users and 2) create IAM policies based on least privilege principles.

- Q: Which of the following is a valid best practices for using the AWS Identity and Access Management (IAM) service? (Select TWO.) A: Create individual IAM users (don't share) and use groups to assign permissions to multiple IAM users.

## EC2

- Q: What is EC2? A: EC2 is a service that provides computing resources in the cloud.

- Q: True or false: EC2 supports Linux only. A: False, EC2 supports Linux, Windows and Mac OS.

- Q: When you launch an EC2 instance, what do you actually need, do you search for an ISO and install the OS manually? A: To launch an EC2 instance you need an AMI. The AMI contains the EBS volume which contains the OS.

- Q: If you need to customize the install of an EC2 instance, do you use user data or meta data? A: User data.

- Q: If you need to look at the metadata of an EC2 instance, how can you get it? A: Login to the EC2 instance and curl http://169.254.169.254/latest/meta-data

- Q: If your EC2 instance need to access AWS services, should you use access keys or IAM roles? A: Use roles. Access keys are in clear text and are not secure.

- Q: If you need to perform some kind of large processing job, what can you use in place of launching EC2 instances? A: You can use AWS Batch.

- Q: If you need an easy way to launch several EC2 instance to host an application, what can you use? A: Lightsail is an easy way to have AWS create the EC2 instances you need to host your application.

- Q: If you need computing resources to run docker containers, what can you use besides EC2 instances? A: ECS, or Elastic Container Service, can be used to run docker containers.

- Q: What are the two launch types that ECS supports? A: ECS supports EC2 launch type and Fargate. With Fargate, AWS will manage the EC2 instances for you. 

- Q: If you want to publish docker images, what can you use besides Dockerhub? A: AWS ECR or Elastic Container Registry.

- Q: Will Amazon automatically patch EC2 instances for you? A: no, you must do this yourself.

- Q: What is the minimum term for reserved instances? A: 1 year. The maximum is 3 years.

- Q: If you need an EC2 instance to run software whose license model is tied to the hardware, what instance type should you use? A: Use dedicated hosts

- Q: What is a dedicated instance? A: A dedicated instance is an EC2 instance whose hardware will remain the same throughout the lifecycle, but may be shared with other customers.

- Q: Which of the following tasks can a user perform to optimize Amazon EC2 costs? (Select TWO.) A: "Implement Auto Scaling groups to add and remove instances based on demand"  and  "Purchase Amazon EC2 Reserved Instances

- Q: If users are not very technical and don't know very much about AWS, what's an easy alternative to using EC2? A: Lightsail is a compute service that is relatively cheap and is easy to deploy by users with little or no AWS expertise. While Lightsail doesn't have as many configuration options, you do have the ability to access the VPC from within the Lightsail instance and gain access to many services. Amazon calls this a simple cloud server. Note that Lightsail does NOT support RedHat Linux.

- Q: When you create an ECS Cluster, what do you need to create inside of each cluster? A: You need to create a task. A task definition defines what container to run.

- Q: If you want to use EC2 instances with ECS, what must you run inside each EC2 instance? A: An ECS agent. If you don't want to manage an EC2 instance then use Fargate. 

## Storage

- Q: If you need to have persistent storage for data attached to EC2 instances, what can you use? A: Use EBS or Elastic Block Store.

- Q: True or false: EBS volumes are global so you can attach the volume to EC2 instances regardless of the AZ. A: False, EBS volumes are local to the AZ.

- Q: If you need to make a backup of an EC2 instance state, what can you use? A: You can create a snapshot. Incidentally, since snapshots are stored on S3, you can create snapshots in order to migrate instances from one AZ to another.

- Q: If you need to share data with multiple EC2 instances, what can you use? A: EFS or Elastic File System lets you share data across multiple EC2 instances and uses NFS. For example, you can have an EFS volume to share data across multiple EC2 instances in multiple AZs.

- Q: What is the maximum file size on S3? A: 5 TB.

- Q: If you want to store data in S3 and want to make sure it's immediately available regardless of cost, what should you use? A: Use S3 standard

- Q: If you want to use S3 and want to save money over the long term, what can you use? A: You can use S3 Inteligent Tiering

- Q: If you want to use S3 but access the data infrequently, what can you use? A: S3 Standard-IA

- Q: If you want to use S3, want to save money, and aren't too concerned if the data is lost, what can you use? A: You can use S3 One Zone IA

- Q: If you want to store data in S3 and want to save as much money as possible, what can you use? A: You can use S3 Glacier or S3 Glacier Deep Archive

- Q: If you need to reduce upload time to S3, what can you use? A: You can use transfer acceleration

- Q: If you're storing sensitive information in S3, what can you do to ensure that the data is secure? A: You can encrypt the data

- Q: If multiple people are uploading data to an S3 bucket, what can you do to get notified? A: You can set up SNS, SQS or Lambda events

- Q: If you're conerned about someone accidentally deleting objects in S3, what can you do? A: You can enable versioning

- Q: If you have on prem servers and want them to access S3 buckets seamlessly (for example, to back up data), what can you use? A: You can use AWS Storage Gateway. Tip: see https://aws.amazon.com/blogs/storage/implementing-a-backup-solution-with-aws-storage-gateway/ on how to implement this at home

- Q: How does Amazon S3 store objects? A: as key key value pairs.

- Q: For an S3 bucket policy, what is the element in the policy that needs to be updated to grant a user access to the bucket? A: A bucket policy is written in JSON. One of the elements of the policy is called Principal and it refers to users. 

- Q: What is the AWS Storage Gateway? A: A hybrid storage service enables a user’s on-premises applications to seamlessly use AWS cloud storage.

- Q: What are the names of two types of AWS Storage Gateway? (Select TWO.) A: File Gateway and Tape Gateway

- Q: What is S3 Transfer Accleration? A: A Service to speed up content transfers to S3 by taking advantage of CloudFront.

- Q: Which type of AWS Storage Gateway can be used to backup data with popular backup software? A: Gateway Virtual Tape Library

- Q: Which statement is true in relation to data stored in S3 buckets? Answer: Data in S3 buckets is not replicated to other buckets unless you configure it.

- Q: Where are Amazon EBS snapshots stored? A: On Amazon S3

- Q: How much data can you store on Amazon S3? A: Virtually unlimited.


## DNS, Elastic Load Balancing, and Auto Scaling

- Q: What is Route 53? A: Route 53 is Amazon's DNS service. It provides domain name registration, DNS to IP translation, and health checking to make sure your application can resolve DNS names.

- Q: What can Route 53 do to help resolve names to IP addresses based on where users are located? A: Route 53 can provide geolocation and geoproximity routing policies. 

- Q: If you just want Route 53 to return the IP that has the smallest latency to user requests, what can you do? A: Set up lowest latency routing polciy on route 53. 

- Q: What is EC2 Auto Scaling? A: EC2 Auto Scaling is a feature in AWS that creates EC2 instances to help scale your deployment. 

- Q: What autoscaling policy can you use to increase the number of EC2 instances based on a schedule? A: Use scheduled scaling. 

- Q: What AWS service helps distribute the load on multiple EC2 instances? A: AWS Elastic Load Balancer or ELB.

- Q: If you need a layer 4 load balancer, what can you do? A: Create a network load balancer (as opposed to an application load balancer). 

- Q: What services does Route 53 provide? Answer: Traffic flow management and domain registration

- Q: What are the primary benefits of using AWS Elastic Load Balancer? A: HIgh availability and Elasticity

- Q: What is the relationship between subnets and availability zones? A: An AZ can has multiple subnets.

- Q: What is contained in an Amazon Virtual Private Coud (VPC)? A: When you create a VPC you also create AZs. You need at least one AZ, but the maximum varies per region. You also define a CIDR block; each AZ will be a part of the CIDR block.

## Application Services

- Q: What are some advantages of serverless computing? A: With serverless, there are no servers to manage. You don't need to setup an EC2 instance, perform OS-level maintainance such as patching, or worry about capacity planning.

- Q: What is AWS Fargate and how is it a serverless service? A: AWS Fargate is a service for running containers and there is no EC2 instance that you need to maintain.

- Q: What is a serverless service for handling message queues? A: Amazon SQS or Simple Queue Service. 

- Q: Does Lambda charge for every function that you create? A: Lambda only charges you when the function is invoked. 

- Q: What serverless service supports a publisher/subscriber model? A: Amazon SNS or Simple Notification Service. Using SNS you can create distributed applications with low coupling.

- Q: What serverless service can you use to respond to events? A: Use EventBridge. 

- Q: What serverless service can you use to publish APIs for users or other services to use? A: Use Amazon API Gateway

- Q: Which AWS services form the app-facing services of the AWS serverless infrastructure? (Select TWO.) A: Amazon API Gateway and AWS Lambda

- Q: What is AWS CodeCommit? A: AWS CodeCommit is a source Control service that is highly secure, scalable and managed.

- Q: A media company wants to find and subscribe to third-party data sources to enrich their existing datasets with new insights. Which AWS service would be the best fit for this requirement? A: AWS Data Exchange is a service where you can subscribe to existing datasets.

- Q: What is Amazon OpenSearch? A: Amazon OpenSearch is a service used to perform queries on data such as logs and text data.

## Networking

- Q: What is a VPC? A: A VPC is a virtual private network dedicated to my account. It's like a network within a data center. 

- Q: How many VPC can you create per region? A: 5

- Q: What is a security group? A: A security group is like a firewall for EC2 instances. 

- Q: Do security groups support deny rules? A: No, security groups only support allow rules.

- Q: If you need to create access rules that support allow and deny rules for ingress/egress traffic through a VPC, what can you use? A: You can create network access control lists (ACLs) for your VPC, specifically ingress rules.

- Q: If you need to have a public IP address for an EC2 instance that does not change if the instance is stopped, what can you use? A: Attach an elastic IP or EIP to the instance.

- Q: If you want your EC2 instance to access the Internet but want to manage the gateway yourself, what can you do? A: Create a NAT instance.

- Q: If you need to route traffic between VPCs, what can you use? A: Use VPC Peering

- Q: If you have servers in a data center and you want them to connect directly to AWS without going through the Internet, what can you use? A: Use AWS DirectConnect.

- Q: If you want to connect multiple VPCs and on-prem servers together, what can you use? A: Use AWS Transit Gateway, which simplifies network configuration.

- Q: If you want to extend your VPC to your data center, what can you use? A: Use AWS Outposts

- Q: True of false: VPC peering routes traffic using private IP addresses: A: True

- Q: What is AWS DirectConnect? A: AWS DirectConnect is a cloud service that links your network directly to AWS. You bypass the Intenet to delive more consistent, lower-latency performance through increased bandwidth.

- Q: When do you use a Virtual Private Network? A: To establish a secure network connection between an on-premises network and AWS

- Q: Which AWS service should a Cloud Practitioner use to establish a secure network connection between an on-premises network and AWS? A: Virtual Private Network

- Q: What is a Network Access Control List? Answer: VPCs can have NACs to act as a fireall for inbound and outbound traffic.

- Q: What is an Internet Gateway? An Internet Gateway is a part of a VPC that allows traffic from the VPc to talk to the Internet.

- Q: Which AWS service or feature can assist with protecting a website that is hosted outside of AWS? A: AWS Web Application Firewall (WAF), if it sits in front of an application load balancer. The key here is "assist" and "protect".

- Q: A company is deploying an application on Amazon EC2 that requires low-latency access to application components in an on-premises data center. Which AWS service or resource can the company use to extend their existing VPC to the on-premises data center? A: AWS Outposts. The keyword here is "extend". Services such as DirectConnect don't extend your VPC, they only give you a private connection between on-premises servers and AWS.

## Deployment and Automation

- Q: If you want your customer to access content more quickly and provide security against DDoS attacks, what AWS service can you use? A: You can use CloudFront which is a CDN that can cache content close to your customers. 

- Q: If you have users in multiple countries and they're experiencing latency when accessing your application, what AWS service can help? A: Use CloudFront

- Q You are trying to access a Cloudfront distribution but cannot see the web site. What is a possible cause? A: Make sure the default root object is set to index.html.

- Q: What Cloudfront feature allows you to exchange data securely with S3? A: Signed URLs.

- Q: What Cloudfront feature allows you to restrict access for multiple files? A:: Cloudfront Signed cookies

- Q: What feature in Cloudfront allows you to restrict access to a select number of countries? A: Cloudfront Geo Restriction

- Q: What service has built-in DoS protection: Route 53, Internet Gateway, Cloudfront or AWS Direct Connect? A: Cloudfront is a CDN which provides built-in DoS protection. Among these, AWS Direct Connect provides a way to connect on-prem machines to AWS and does not provide DoS protection.

- Q: What types of Origin does Amazon Cloudfront support? A: S3 bucket and EC2 instance

- Q: If you have EC2 instances in multiple regions that need fast network connectivity to each other, what can you use? A: AWS Global Accelerator, which uses the AWS global network.

- Q: If you're deploying AWS resources by hand and are afraid of human error, what can you use? A: AWS CloudFormation is an automated way to provision AWS resources using code.

- Q: True or false: CloudFormation is powerful but there is a charge to use. A: False, you're only charged for the resources you use.

- Q: If you'd rather create AWS infrastructure using code instead of YAML. what can you use? A: AWS provides a CDK or Cloud Development Kit that allows you to create infrastructure using any of a variety of programming languages.

- Q: If you want to deploy an application to AWS but don't want to get into the details of managing load balancers, databases, ASGs and networking, what service can help? A: Elastic Beanstalk is a managed service for creating all of these.

- Q: If you're trying to debug a distributed application on AWS, what service can you use? A: AWS X-Ray.

- Q: What types of Origin does Amazon CloudFront support? A: S3 bucket and EC2 instances can be used as origins for CloudFront.

- Q: What is the name for the configuration item that holds a collection of records belonging to a domain? A: A Hosted Zone is a container for records that map hostnames to IPs.

- If you want to set up continuous integration in AWS, what services can you use? A: AWS CodeCommit and AWS CodeBuild

- If you want to develop code within AWS, what AWS Service can let you do that? A: AWS CodeStar

- Q: Is AWS Elastic Beanstalk the fastest way to deploy popular IT solutions? AL No, you still need to provide the code. Use AWS Quick Start reference deployments instead; these are Cloud Formation templates.

- Q: What is AWS Cloudfront? A: AWS Cloudfront is a service used to reduce latency and improve transfer speeds. It is designed for static assets like videos, images and files that don't change and can be cached.

- Q: What is Global Accelerator? A: A service that finds the optimal route to your services via edge locations.

- Q: What types of monitoring can Amazon CloudWatch be used for? A: Application performance and operational health, which includes CPU and network utilization. These can be configured for alarms if they exceed a threshold value.

- Q: Can AWS Systems Manager be used to launch a new ElastiCache cluster? A: No, Systems Manager cannot create any AWS services such as ElastiCache for you.


## Databases and Analytics

- Q: If you need a managed OLTP database service, what can AWS provide? A: Use RDS

- Q: How do you increase the capacity of an Amazon RDS database? A: Change the database to use a larger instance type

- Q: Will RDS automatically scale for you? A: Since RDS uses EC2 instances, you must choose the family/type at the outset.

- Q: Why might an organization decide to move an on-premises database to Amazon RDS? A: to reduce operational overhead.

- Q: If you have an RDS database and you need to scale out for reads or queries only, what can you do to tune the database? A: Create a read replica. 

- Q: If you need to ensure that your RDS database is tolerant of failures in your AZ, what option do you have? A: Set up disaster recovery with multi-AZ option. This falls into the reliability pillar of the Well Architected Framework. Other features such as replicas and snapshots do not provide fault tolerance.

- Q: A company wants to improve their RDS performance and decrease latency by using an AWS DB caching service. Which of the following would you recommend they use? A: ElastiCache, which provides in-memory caching (it is essentially Redis)

- Q: What is Amazon Aurora? A: Aurora is a database provided by RDS that is compatible with MySQL and PostgresSQL and is built for the cloud. 

- Q: If you need a key-value NoSQL managed database, what can you use? A: Use Amazon DynamoDB, where you create a table and define your key-value entries in it. 

- Q: Is DynamoDB an example of horizontal scaling or vertical scaling? A: Horizontal Scaling

- Q: What is DynamoDB Accelerator or DAX? A: DAX is a fully-managed in-memory cache for DynamoDB that increases performance by reducing latency to microseconds. 

- Q: If you want to use DynamoDB and have it replicate to multiple regions, what can you do? A: Use Global Tables, which is a fully managed multi-region, multi-master solution.

- Q: If you have a lot of data and want to perform analytics on it, would you use DynamoDB or RDS? A: Neither. Amazon has a service called RedShift which is a SQL based data warehouse for this purpose. 

- Q: If you want to perform analytics on your Apache Hadoop or Apache Spark database, what can you use? A: Amazon EMR, or Elastic Map Reduce.

- Q: Besides DynamoDB, what other AWS service provides key/value storage? A: Amazon ElasticCache. You can use it in front of databases like DynamoDB or RDS for better performance.

- Q: If you need to run SQL queries against data in an S3 bucket, what AWS service can you use? A: Use Amazon Athena. It can analyze data in S3 buckets at the petabyte-scale level. It is also serverless so there are no EC2 instances to manage.

- Q: If you need an AWS service for ETL jobs on data stored in S3, what can you use? A: AWS Glue is a fully managed ETL service that runs Apache Spark and can be used for running analytics on data.

- Q: If you need an AWS service for processing streaming data, what can you use? A: Use Amazon Kinesis.

- Q: What is a "shard"? A: A shard is a container for data in Amazon Kinesis. 

- Q: If you need a business intelligent or BI dashboard for machine learning-powered insights, what can you use? A: Use Amazon QuickSight.

- Q: If you need to process and move data between different AWS compute and storage services, what can you use? Use AWS Data Pipeline

- Q: If you need a fully managed graph database, what AWS service can you use? A: AWS Neptune

- Q: If you need to query and index JSON data, what AWS service can you use? A: Amazon DocumentDB.

- Q: How can a company migrate a database running in an EC2 instance to RDS without downtime? A: Migrate using AWS Database Migration Service

- Q: A company needs to migrate several TB of data from an on-premises NAS device to Amazon FSx. Which service can the company use to migrate the data over a VPN connection? A: AWS DataSync

- Q: Which AWS-managed service can be used to process vast amounts of data using a hosted Hadoop framework? A: Amazon EMR (Elastic Map Reduce)

- Q: How are Amazon EC2 instances billed, by the hour? Second? A: It depends. EC2 instances running Linux or Windows are biled by the second. Others are billed by the hour. Any partial hours are billed as a full hour for these other instance types.

- Q: What is RDS? A: Amazon RDS is a relational database service that is compatible with several database engines, including MySQL. A key benefit is that it simplifies database administration by providing automated backups and automated software patching. RDS provides automated backups by default.

- Q: What is AWS Glue? A: AWS Glue is a service used to load data from Amazon S3, transform it, and move it to another destination. It is termed "Serverless data integration".

- Q: An application stores images which will be retrieved infrequently, but must be available for retrieval immediately. Which is the most cost-effective storage option that meets these requirements? A: Amazon S3 Standard-IA for infrequent access.

- Q: What is AWS Athena? A: A service can be used to query data in S3 using standard SQL

- Q: What is Amazon Neptune? A: Amazon Neptune is a graph database service.

- Q: What is DynamoDB? A: A key-value database that scales horizontally.

- Q: Which items are you charged for when using RDS? Answer: Outbound data transfer and multi-AZ.

- Q: A financial services firm wants to build a real-time analytics platform where data can be streamed and analyzed on the fly. They are looking to use Apache Kafka for this, but they want to avoid the overhead of managing the Kafka infrastructure. Which AWS service would be the best fit for this requirement? A: Amazon MSK (Managed Streaming Service for Kafka). Unlike Kinesis, MSK does not leverage Kafka.

## Management and Governance

- Q: What AWS service can you use to consolidate multiple AWS accounts into an organzation? A: AWS Organizations lets you do this. Once you set up an AWS Organization, you can consolidate billing. 

- Q: True or false: AWS Organizations has an API that lets you programatically create user accounts. A: True.

- Q: What service simplifies the creation of multiple user accounts? A: AWS Control Tower lets you do this, and sets up governance compliance and security gaurdrails. It integrates with AWS Organizations. 

- Q: What service helps you manage many AWS services such as EC2? For example, if you need to run a command on multiple EC2 instances. A: AWS Systems Manager lets you do this. You can use Systems Manager to gather inventory. You can also use Systems Manager to do things like patching, connecting to EC2 instances and storing secrets for EC2 instances.

- Q: If you are managing an AWS Organization, what service can you use to manage services that users can use? A: The AWS Service Catalog service lets you create a catalog of services that are approved for users.

- Q: What AWS service can be used for compliance management? A: AWS Config can be used to audit your AWS infrastructure. For example, you can set up a rule that checks for security groups that allow inbound access beyond what you define as acceptable. 

- Q: If you're worried about expenses in the cloud and need help to determine how to reduce cost, increase performance, and improve fault tolerance AND security, what AWS service can help? A: Trusted Advisor can provide real-time guidance on all of these based on best practices.  Cost Explorer can help you view itemized cost, but you can't use it to check resource utilization. 

- Q: What AWS service can you use to check the health of your AWS infrastructure? A: Use AWS Health Dashboard. There are actually two features. The first is service health, which shows you the health of AWS services in general The other is called "Your account health", which is personalized. 

- Q: What service can help you determine the optimal sizing for EC2 instances that you use to run workloads? A: AWS Compute Optimizer can help you do this. To change the instance type of an EC2 instance, all you have to do is stop the instance, change the type, and start the instance again. 

- Q: What service can provide a guided way to launch EC2 instances for some services by providing recommended sizing and configuration options? A: AWS Launch Wizard can help you create EC2 instances that are optimal to the third-party application you want to deploy on AWS. You are not charged for using Launch Wizard; you are charged for the EC2 instance. 

- Q: What is AWS Trusted Advisor? A: AWS Trusted Advisor provides real time guidance to help you provision your resource following best practices in the areas of cost optimization, performance, security and fault tolerance. 

- Q: When do you use Trusted Advisor? A: When you need a service to identify if unrestricted access to resources has been allowed by security groups. 

- Q: What is AWS Organizations? A: AWS Organizations is a service that gives you the ability to centrally manage multiple AWS accounts. Some benefits include: you wil receive one bill for all accounts in the organization and 2) the unit pricing may be cheaper.

- What is AWS Systems Manager? Answer: A service to manage and troubleshoot nodes, including Amazon EC2 instances, edge devices, and on-premises servers and virtual machines.


## AWS Cloud Security and Identity

- Q: If you want to authenticate users using Active Directory that's fully managed, what can you use? A: You can use AWS Directory Service for Microsoft Active Directory. If you want to use an Active Directory that's running on-prem, then AWS provices an AD Connector. Or if you just want a low scale, low cost active directory that's based on Samba, then use Simple AD. 

- Q: If you need to store things like passwords, is there an AWS service for this? A: You can use AWS Systems Manager Parameter Store or AWS Secrets Manager. With Secrets Manager, you can rotate keys and have fine-graned permissions.

- Q: If you need manage encryption keys used for things like SSH or encrypting data, what service can be used? A: You can use AWS KMS or Key Management Service.

- Q: If you need a hardware security model, would you use KMS? A: No, AWS provides CloudHSM.

- Q: If you need to troubleshoot your services at the API level and find out what was happening in the last 90 days, what can you use? A: Use AWS CloudTrail. 

- Q: If you want to retain CloudTrail logs for more than 90 days, what can you do? A: Configure CloudTrail logs to store logs in

- Q: If you're trying to SSH to an EC2 instance and you're having issues, would you use AWS CloudTrail? A: You might want to look at VPC Flow Logs, which capture the network "flow".

- Q: If you're trying to troubleshoot an issue with a user going through a load balancer who is trying to get objects from an S3 bucket, what kinds of logs can you look at? A: You could look at load balancer access logs first, and then if those look okay you could look at S3 access logs. 

- Q: If you want to use a service to try to identify suspicious activity in your account, what can you use? A: AWS Detective or GaurdDuty

- Q: If you want to lock down S3 and make sure your buckets follow security best practices, what can you use? A: AWS Macie is a service that can be used to discover and protect sensitive data in AWS. It only scans S3 buckets.

- Q: If you need a web application firewall and you're trying to block common web exploits such as XSS, what can you use? A: AWS WAF is a web application firewall service. It would be handy to set this up if you're running any web application that uses ports like 80, 8443, or 8080. Also you sould set up AWS Shield to prevent DDoS.

- Q: What is AWS Shield? A: AWS Shield is a service that provides protetion against Denial of Service attacks. 

- Q: If you need to provide compliance reports to auditors. what can you use? A: Use AWS Artifact

- Q: If you need a comprehensive view of security alerts across AWS accounts and services, is there some kind of dashboard for this? A: Use AWS Security Hub.

- Q: If you need help from AWS to help mitigate a security breach, who coan you contact? A: AWS Trust & Safety Team

- Q: What is AWS' policy regarding penetration testing? A: You can perform penetration testing against several services without approval

- Q: If you want to monitor EC2 instances and check that the sizing is correct, what service can you use? A: Amazon CloudWatch can be configured to send out alerts if EC2 intances use high levels of CPU. If you want AWS to provide recommendations for you, AWS Compute Optimizer is a managed service for this.

- Q: When should you report to the AWS Trust and Safety Team? A: For example, when you notice that an EC2 instance is being used to attempt to flood ports on some of the company’s systems.

- Q: What is AWS CloudTrail? A: A service used for auditing API actions. It can be used to track the activity of users.

- Q: What is AWS CloudHSM? A: A cloud-based hardware security module (HSM) that enables you to easily generate and use your own encryption keys on the AWS Cloud.

- Q: A new user is unable to access any AWS services, what is the most likely explanation? A: By default new users are created with NO access to any AWS services –-  they can only login to the AWS console. You must apply permissions to users to allow them to access services.

- Q: What is AWS Inspector? A: AWS Inspector is an AWS service which can be used to create an automated security assessment report that will identify unintended network access to Amazon EC2 instances and vulnerabilities on those instances.

- What service can be used to identify a specific user who terminated an Amazon RDS DB instance? A: AWS CloudTrail, which is used for auditing user actions in AWS. 

- Q: What is VPC Flow Logs? A: A service that enables you to capture information about the IP traffic going to and from network interfaces in your VPC. 

- Q: What is Amazon GuardDuty? A: A threat detection service

- Q: Which of the following can be assigned to an IAM user? Answer: An access key ID and secret access key for API access and a password for accessing the managment console.

- Q: Which feature of AWS IAM enables you to identify unnecessary permissions that have been assigned to users? A: IAM Access Analyzer

- Q: Which of the following is NOT a best practice for protecting the root user of an AWS account? A: Remove administrative permissions

- Q: Your manager has asked you to explain some of the security features available in the AWS cloud. How can you describe the function of Amazon CloudHSM? A: It can be used to generate, use and manage encryption keys in the cloud. It is based on hardware.

- Q: Which of the following are NOT features of AWS IAM?  A: Login in to the console using local user accounts and charging for what you use.

- Q: What is Cognito? A: Cognito is an identification platform for web and mobile apps. 

## Architecting for the Cloud

- Q: How can AWS lower operational cost? A: By providing high-level managed services, users spend less effort on maintainance. 

- Q: Does EC2 Auto Scaling Groups provide horizontal or vertical scaling? A: Horizontal scaling by changing the number of EC2 instances based on some criteria. It does not change the instance type. 

- Q: Is an Amazon Read Replica an example of horizontal or vertical scaling? A: Horizontal scaling, since it adds another RDS instance.

- Q: Should you design for failure in the cloud? A: Absolutely

- Q: Does DynamoDB scale horizontally or vertically? A: Horizontally

- Q: If you're trying to reduce interdependence between application components, what is the ultimate goal? A: Loose coupling, so that failure of one service does not cause other services to fail

 - Q: If you use a load balancer, does this provide horizontal scaling or vertical scaling? A: Horizontal scaling

## Accounts, Billing and Support 

- Q: What is the difference between dedicated instances and dedicated hosts? A: A dedicated instance gives you physical isolation at the host level but you're still using a VM. A dedicated host is where you actually reserve a physical server for your use and is useful when the software you want to use is bound to the hardware. 

- Q: What is the standard (as opposed to expedited or bulk) access time for data in S3: in minutes or hours? A: Hours

- Q: If you create an EBS volume but it isn't attached to an EC2 instance, are you still charged? A: Yes, EBS volumes are charged regardless.

- Q: Are EBS snapshots charged? A: Snapshots store data in S3 and they are charged.

- Q: If you have an RDS service that's idle, would you still be charged for it? A: Absolutely, you are billed by the hour but he amount depends on the database engine and the sizing.

- Q: If you have data stored in DynamoDB that you want to just access but not write to, would you still be charged? A: Yes, you are charged for reads and writes.

- Q: If you want to provision a DynamoDB service that will have a predictable workload, what can you do to reduce cost? A: Set up the DynamoDB service to use provisioned capacity mode instead of on-demand capacity mode. 

- Q: Does Lambda charge by the hour, minute, or millisecond? A: Millisecond

- Q: If you have many user accounts, is there anything you can do to reduce cost? A: Use AWS Organizations and get volume pricing

- Q: If you're trying to reduce cost and want to get an alert if your usage goes above budget, what can you do? A: Set up alerts in AWS budgets.

- Q: If you want to look at your usage of AWS services over time and look for problem areas, what service can help you do this? A: Use AWS Cost Explorer

- Q: If you're only goal is to store data in S3, are you chartged for this? A: No, you are charged for outbound data transfer only.

- Q: What is a key cost advantage of moving to the AWS Cloud? A: You can provision what you need and scale on demand.

- Q: What is the best tool for an organization to compare the cost of running on-premises to using the AWS Cloud? A: The TCO Calculator can be used to estimate the savings when comparing the AWS Cloud to an on-premises environment

- Q: Which AWS support plan comes with a Technical Account Manager (TAM) A: Enterprise

- Q: Which of the following needs to be considered in a Total Cost of Ownership (TCO) analysis? A: Data center operations costs.

- Q: Which AWS pricing feature can be used to take advantage of volume pricing discounts across multiple accounts? A: Consolidated billing.

- Q: Which tool can an IT manager use to forecast costs over the next 3 months? A: AWS Cost Explorer.

- Q: What is AWS Cost Explorer? A: It is a tool to visualize, understand, and manage your AWS costs and usage over time.

- Q: Which pricing model is best suited for a batch computing workload that requires significant compute power and can be stopped at any time? A: Spot Instances

- Q: Which storage classes are available for the Amazon Elastic File System? A: In order of cost Standard, Backup, Infrequent Access and Archive. The cost depends on factors such as region.

- Q: Do NAT Gateways have a cost? A: They are charged by the hour.

- Q: What is the purpose of the NAT gateway? A: A NAT gateway is the primary means by which an EC2 instance launched in a private subnet can talk to the outside world. This can be useful for installing and updating software. In order to access EC2 instances with only private IPs, we could launch a bastion server in the public subnet of the VPC. EC2 instances in the same VPC can talk to each other. You want to configure the security group of the private instances to alllow SSH traffic (port 22) from the bastion host's security group. See https://medium.com/@tejasmane485/aws-bastion-host-secure-remote-access-to-your-private-instances-7012a5a74fb3. 

- Q: What does AWS recommend that you do to setting up a cost allocation report? A: Assign cost allocation tags to your resouces.

- Q: Which tasks require the use of the AWS account root user? (Select TWO.) A: Changing the account name and Changing AWS Support plans

- Q: Which of the statements below is correct in relation to Consolidated Billing? A: You receive a single bill for multiple accounts and You can combine usage and share volume pricing discounts

- Q: What is a Technical Account Manager? A: A technical account manager is a point of contact who can provide technical support. It comes with Enterprise Support.

- Q: Which AWS support plans provide 24x7 access to customer service? A: All plans

- Q: A user has an AWS account with a Business-level AWS Support plan and needs assistance with handling a production service disruption. Which action should the user take? A: Open a "production system down support case".

- Q: What is AWS Concierge? Answer: a team to support AWS customers on an Enterprise support plan with account issues.

- Q: Does Developer support plan provide phone support? A: No, only email. Developer support is the only support plan that provides email only support.

- Q: What do APN Consulting Partners do? A: They help organizations design, build and manage workloads on AWS.

- Q: Which support plan is the lowest cost option that allows unlimited cases to be open? A: Developer

- Q: Does the Basic suport plan provide email support? A: No, this starts from Developer.

## Migration, Machine Learning and More

- Q: what appliance in the Snow Family can be used to migrate data in the terabytes: AWS Snowcone or AWS Snowball? A: Both can be used. Snowcone is small and has 8 TB of usable HDD storage while Snowball weighs 50 lbs and has 80 TB of usable HDD storage. 

- Q: A company recorded some support call conversations in mp4 files. How can the company extract the audio into a text document? A: AWS Transcribe

- Q: What is Amazon Elastic Transcoder? A: A service to transcode (convert) media files like movies into a format that client devices can use.

- Q: An application is being built that needs to identify faces in images. Which service can be used? A: AWS Rekognition

- Q: A company is looking to use machine learning to translate a few documents from English to Chinese. Having learned about machine learning services on AWS, which of the following services would you recommend the company to use? A: AWS Translate

- Q: A company is planning on implementing a chatbot into their web application. Which AWS service would best meet their needs? A: Amazon Lex

- Q: A company wants to develop their own machine learning application on AWS. Which of the following services would best fit their needs? A: Amazon SageMaker

- Q: Which of the following services offers Text-to-Speech (TTS) services? A: Amazon Polly

- Q: If you want to deploy containers but don't want to manage servers, and you need certain advanced features such as machine learning, is there any reason not to use EKS? A: Using EKS requires expert knowledge of Kubernetes. It can also cost a lot more.

- Q: A company needs to migrate several TB of data from an on-premises NAS device to AWS over the network. Which service can the company use to migrate the data over a VPN connection? A: Use AWS DataSync.

- Q: If you're looking for a service to help find experts who can help you deploy or manage or AWS infrastructure, what can you use? A: AWS IQ 

- Q: If you are a startup and you're looking for help to leverage AWS in your operations, what can you use? A: AWS Activate is a program that provides startups with AWS credits, training, and tech support. 

- Q: What is AWS Snowball? A: A service used to migrate lots of data from on-premises to the cloud.

## References

- https://www.udemy.com/course/aws-certified-cloud-practitioner-training-course

- https://d1.awsstatic.com/training-and-certification/docs-cloud-practitioner/AWS-Certified-Cloud-Practitioner_Exam-Guide.pdf 

- https://d1.awsstatic.com/whitepapers/aws-overview.pdf