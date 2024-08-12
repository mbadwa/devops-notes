# AWS Notes

## VPC Intro

VPC is a logical data center within an AWS Region. You can use default VPC or a custom VPC. VPC is an on-demand configurable pool of shared computing resources allocated within a public cloud environment. You have control over network environment, select IP address range, subnets and configure route tables and gateways.

### IPv4 Address
An IPv4 is a decimal presentation of a 32 bit binary number divided into 4 octets that each represent 8 bits. 

![IPv4 Address](./IPv4%20Diagram.drawio.png)

IPv4 Range in decimal

    0.0.0.0 - 255.255.255.255

IPv4 Range in binary

    00000000.00000000.00000000.00000000 (0.0.0.0) - 11111111.11111111.11111111.11111111 (255.255.255.255)

Public IP => Internet

    E.g. 54.68.23.90

Private IP => For local network design

    E.g. 192.168.1.10

Private IP Ranges

    Class A 10.0.0.0 - 10.255.255.255
    Eg. 10.16.250.120
    
    Class B 172.16.0.0 - 172.31.255.255
    E.g. 172.16.25.10

    Class C 192.168.0.0 - 192.168.255.255
    E.g. 192.168.1.25

Subnet Mask

Subnet mask is a logical division between network and the host portions of the IP address. The network and the broadcast addresses are determined based on the subnet mask.

    255.0.0.0

    255.255.0.0

    255.255.255.0

For example

    IP address: 192.168.100.41
    Subnet Mask: 255.255.255.0

    Network IP:  192.168.100.0
    First Host:  192.168.100.1
                 192.168.100.2
                 .
                 .
    Last Host:   192.168.100.254
    Broadcast IP:192.168.100.255

    Total IPs:   256
    Total Usable IPs: 254
    

All the information is derived from the subnet mask

CIDR Notation

    # CIDR number is determined by the number of 1s in each mask
    
    255.0.0.0
    11111111.00000000.00000000.00000000
    /8

    255.255.0.0
    11111111.11111111.00000000.00000000
    /16

    255.255.255.0
    11111111.11111111.11111111.00000000
    /24


Network Range

    172.16.0.0/16

Subnet 172.16.20.0.0/24

    172.16.20.1.0/24
    172.16.20.2.0/24
    172.16.20.3.0/24
    172.16.20.4.0/24

    etc.

You can use [subnet calculator](https://jodies.de/ipcalc)

### VPC Design Components Infra


![VPC Components](./High%20Level%20AWS%20Infra.png)

#### VPC Components in the Infra

1. VPC
   - The VPC is just like the virtual data center in a particular region, e.g. us-east and then you can have resources in zones. A VPC is a private resource within the public cloud.

2. Zones
   - In this infrastructure the resources are hosted in different Zones for segregation and security. Availability Zone A (us-east-1), and Availability Zone B (us-east-2).

3. Public Subnet
   - All resources facing the internet resides in Public Subnet, here we have two web servers for load balancing. 

4. Private Subnet
   - All resources that doesn't require to be accessed from internet resides in Private Subnet. In our example we have an App Server and two DB servers. These resources can't be accessed from internet for security reasons. However, they can reach the internet through the VPC NAT Gateway. They send their traffic to NAT GW and then the NAT GW forwards it to the Internet Gateway. The return traffic is allowed too.

5. VPC NAT Gateway
   - NAT Gateway acts like a home router in a sense. Where it'll have a public IP and Private IPs. It resides in the Public subnet so it can communicate with the Internet Gateway. The resources in the Private Subnet are assigned private IP address and then the NAT GW translates them to public mapping that then talks to IG and vice versa with the returning traffic.

#### VPC Design Components Infra

![Private/Public Components](Public%20&%20Private%20Subnets.png)

#### VPC Components in the Infra

1. Route Table
   
   - A route table is attached to each of the Subnets through a Network ACL and the other end it is attached to a router. This will determine if the traffic has to go to the internet or not. 

2. Network Access Control List 
   
   - A Network ACL acts as a gate traffic checker to see which type of traffic is allowed in and out of the subnet. If the particular traffic is not allowed then it gets dropped.
   
3. Security Group
   
   - Security Group determines which type of traffic is allowed into a resource, this could be traffic within the VPC or from outside the VPC.

4. Router
   
   - The traffic from Route Table is sent to the router and gets transferred either to another subnet or out to the internet through IG or out through VPN Gateway if the traffic was received through it.

5. EC2
   - All traffic requests that gets allowed through the Network ACL (NACL) and through the Security Group gets processed by the target EC2 instance.
  
### VPC High Availability Design

![VPC HA Design](High%20Availability%20VPC.png)

#### Design Components in the Infra

1. NAT Gateway
2. Route Table
3. EC2
4. MySQL DB
5. Bastion Host
   - Used for accessing EC2 instances that are in private subnet from the internet. Acts as an entry point into a secure network to access resources in a private subnet. All resources created in the private subnet won't have public IPs hence not accessible from the internet. To ssh into resources residing in private subnet, you need ssh into resources in the public subnet then jump into the private subnet. That's the function of the bastion host. 
6. Cache Node
7. Internet Gateway
8. Redundant Availability Zones
9. Redundant Subnets in each AZ

### Blueprint

1. VPC Network Range

    - Network: 172.20.0.0/16

    - Divided into 4 subnets

        - 2 Public Subnets
        - 2 Private Subnets
   - Subnets Allocation
     - pub-sub1[us-west-1a]: 172.20.1.0/24
     - pub-sub2[us-west-1b]: 172.20.2.0/24
     - priv-sub1[us-west-1a]: 172.20.3.0/24
     - priv-sub2[us-west-1b]: 172.20.4.0/24
    
2. Region and Zones

   - Region: us-west
   - Zones: 
     - us-west-1a
     - us-west-1b

3. VPC Components
    - 1 Internet Gateway
    - 2 NAT Gateway for HA
    - 2 Elastic IPs for each NAT Gateway
    - 2 Route Tables
      - Public Subnet
      - Private Subnet
    - 1 Bastion Host/Jump Server in Public Subnet
    - NACL for the public subnet
  
  Note: For lab purposes use 1 Elastic IP and 1 NAT Gateway

4. Additional VPC
   - 1 more VPC for VPC peering with the main VPC above


**Steps**

1. In the console switch to US West(N.California Region)
2. Search for VPC
3. Familiarize with VPC menus
4. Default VPC*
   - Click on VPC Dashboard and scroll to far right > Default VPC: Yes
   - Scroll back and name the VPC to DEFAULT VPC
   - Click on Subnets and rename them
     - Name: Default-pubsub1
     - Name: Default-pubsub2
   - Click on any subnet > Route table > Routes
     - A local traffic route within the VPC as its Destination, its target as local
     - Internet traffic route entry to any Destination (0.0.0.0/0) with a Target of the IGW
  
    **Note**: Never Delete default resources. If the subnets are routing the traffic through the Route table to a NAT Gateway then that's private subnet's traffic. Otherwise, if the subnets are routing traffic through the Route table to IGW then it's the traffic for the public subnet.
5. Manual VPC Creation
   
   1. VPC Creation
      - Hit the Create VPC > VPC only
      - Name tag - optional
        - "vprofile-VPC"
      - IPv4 CIDR
        - 172.20.0.0/16
      - Tenancy
        - Default
      - Tags > Name
        - Leave the populated one
      - Hit Create VPC
   2. Subnets Creation
      - Go to Subnets > Create subnet
      - VPC > VPC ID
        - Select the "vprofile-VPC"
      
      - Hit the "Add new subnet" 3 times
        
        - Subnet name
          - vpro-pubsub1
        - Availability Zone
          - us-west-1a
        - IPv4 subnet CIDR block
          - 172.20.1.0/24
        - Tags - optional
          - Leave the already populated
        
        - Subnet name
          - vpro-pubsub2
        - Availability Zone
          - us-west-1b
        - IPv4 subnet CIDR block
          - 172.20.2.0/24
        - Tags - optional
          - Leave the already populated
  
        - Subnet name
          - vpro-privsub1
        - Availability Zone
          - us-west-1a
        - IPv4 subnet CIDR block
          - 172.20.3.0/24
        - Tags - optional
          - Leave the already populated
  
        - Subnet name
          - vpro-privsub2
        - Availability Zone
          - us-west-1b   
        - IPv4 subnet CIDR block
          - 172.20.4.0/24
        - Tags - optional
        - Leave the already populated  
   3. Internet Gateway Creation
         - Go to Internet gateways > Create internet gateway
           - Name tag
             - "vprofile-IGW"
           - Hit Create internet gateway
           - Hit Actions > Attach to VPC
             - Select vprofile-VPC
           - Hit Attach internet gateway
   4. Route Table Creation to connect pub-subs to IGW
         - Rename the listed route tables accordingly
           - Name
             - vprofile-default-RT
           - Name
             - DEFAULT Pub-RT 
         - Click on Route tables > Create route table
           - Name - optional
             - vpro-pub-RT
           - VPC
             - Select the vprofile-VPC
           - Tags
             - Leave the auto filled
           - Hit Create route table
         - Go to Subnet Associations tab > Edit subnet associations
           - Select "vpro-pubsub1" and "vpro-pubsub2"
         - Hit Save associations
         - Go to Edit routes > Add route
           - Destination
             - 0.0.0.0/0
           - Target
             - Internet Gateway
               - vprofile-IGW
           - Hit Save changes
   5. Enable public-IPs on pub-subs
         - Go to Subnets > vpro-pubsub1 > Actions > Edit subnet settings
           - Auto-assign IP settings
             - Check the Enable auto-assign public IPv4 address box
         - Hit Save
         - Go to Subnets > vpro-pubsub2 > Actions > Edit subnet settings
           - Auto-assign IP settings
             - Check the Enable auto-assign public IPv4 address box
         - Hit Save
   6. Elastic IP Creation to associate with NAT GW
         - Go to Elastic IP addresses > Allocate Elastic IP address
         - Tags - optional
           - Key: Name
           - Value: vprofile-NAT-EIP
         - Hit Allocate
   7. NAT Gateway
         - Go to NAT gateways > Create NAT gateway
           - Name - optional
             - vpro-NAT-GW
               - Subnet
                 - vpro-pubsub1
               - Elastic IP allocation ID
                 - vprofile-NAT-EIP
               - Tags
                 - Leave auto populated
         - Hit Create NAT Gateway
         - Repeat for vpro-pubsub2
     
           **Note**: NAT gateway lives in public subnet but serves private subnets to connect to internet by passing its traffic to Internet Gateway.
   8. Create Route Table for vpro-privsub1 and vpro-privsub1, attach it to NAT Gateway
         - Go to Route tables > Create route table
           - Name - optional
             - vpro-priv-RT
           - VPC
             - vprofile-VPC
           - Tags
             - Leave the auto populated
         - Hit Create route table
         - Go to Subnet associations > Edit subnet associations
           - Select vpro-privsub1 and vpro-privsub2
         - Hit Save associations
         - Go to Routes > Edit routes
           - Add route
             - Destination
               - 0.0.0.0/0
             - Target
               - NAT Gateway
                 - vpro-NAT-GW
         - Hit Save changes
      
   9.  Enable DNS hostnames for EC2s
          - Go to Your VPC > vprofile-VPC > Actions > Edit VPC settings
            - DNS settings
              - Check the Enable DNS hostnames box
          - Hit Save
   10. Bastion host/Jump server
          - Go to EC2 > Security Groups > Create security group
            - Name
              - vpro-bastion-SG
            - Description
              -  vpro-bastion-SG
            - VPC
              - vprofile-VPC
            - Inbound rules > Add rule
              - Type: SSH, Protocol: TCP, Port: 22, Source: My IP, Description: SSH to Bastion from my corporate network
          - Hit Create security group
  
   11.  Create a key pair
          - Go to Network & Security > Key Pairs > Create key pair
            - Name:
              - vpro-bastion-key
            - Create key pair
   12.  Launch instance
          - Go to Instances > Launch instances 
            - Name:
              - bastion
            - Application and OS Images (Amazon Machine Image)
              - Ubuntu Server 22.04 LTS
            - Instance type
              - t2.micro
            - Key pair(login)
              - vpro-bastion-key
            - Network settings > Edit
              - vprofile-VPC
            - Subnet
              - Select either vpro-pubsub1 or vpro-pubsub1
            - Firewall (security groups)
              - Select existing security group
                - vpro-bastion-SG
            - Hit Launch instance
       
             **Note**: In production use cis AMIs- vulnerabilities tested AMIs by going to Go to Instances > Launch instances > Browse more AMIs > AWS Marketplace AMIs
   13. Key pair for EC2 instances in private sub
          - Go to Network & Security > Key Pairs > Create key pair
           - Name:
             - vpro-web-key
          - Create key pair
   14. Copy the vpro-web-key to the bastion host
  
            chmod 400 Downloads/vpro-web-key.pem

            # scp -i Downloads/vpro-bastion-key.pem Downloads/vpro-web-key.pem ubuntu@bastion-public-ip:/home/ubuntu
            scp -i Downloads/vpro-bastion-key.pem Downloads/vpro-web-key.pem ubuntu@54.177.172.149:/home/ubuntu

            # ssh -i Downloads/vpro-bastion-key.pem ubuntu@bastion-public-ip
            ssh -i Downloads/vpro-bastion-key.pem ubuntu@54.177.172.149

            ls -l

   15. Create a web server
          - Go to EC2 > Instances > Launch an instance
             - Name
                - web01-priv
             - Amazon Machine Image (AMI)
                - Amazon Linux 2 AMI (HVM)
             - Instance type
                - t2.micro
             - Key pair (login)
                - vpro-web-key
             - Network settings > Edit
                - vprofile-VPC
             - Subnet
                - Select vpro-privsub1 or vpro-privsub2
             - Security group name - required
                - web01-SG
             - Description - required
                - web01-SG
             - Inbound Security Group Rules
               - Type: ssh, Protocol: TCP, Port range:22
               - Source type: Custom, Source: vpro-bastion-SG, Description: vpro-bastion-SG
         - Hit Launch instance
     
   16. SSH into the the web01-priv from the Bastion host

            ssh -i vpro-web-key.pem ec2-user@private-ip
            ssh -i vpro-web-key.pem ec2-user@172.20.3.218
   17. Set up website
   
        1. Install dependencies
    
                sudo -i
                yum install httpd wget unzip -y
            
        2. Go to https://www.tooplate.com/view/2133-moso-interior, choose any site you like.

                fn + f12
        
        3. Click on Download, hit Cancel button and copy the .zip URL

                https://www.tooplate.com/zip-templates/2133_moso_interior.zip

        4. Download the file from web01 server

                wget https://www.tooplate.com/zip-templates/2133_moso_interior.zip && unzip 2133_moso_interior.zip

                cp -r 2133_moso_interior/* /var/www/html/

                systemctl restart httpd && systemctl enable httpd && systemctl status httpd

   18. Load Balancer Creation for web01 access
        1. Create a target group
           - Go to Target groups > Create target group
             - Choose a target type
               - Instances
             - Target group name
               - vpro-web-server-TG
             - Protocol: Port 
               - HTTP, Port: 80
             - VPC
               - vprofile-VPC
             - Hit Next
             - Register targets > Available instances 
                 - Select instance
                   - web01-priv
                 - Hit Include as pending below
             - Hit Create target group
        2. Create a Security group for LB
            - Go to Network & Security > Security Groups > Create security group
              - Security group name
                - web-elb-SG
              - Description
                - web-elb-SG
              - VPC
                - vprofile-VPC
              - Inbound rules > Add rule
                - Type: Custom TCP, Protocol: TCP, Port: 80, Source: Anywhere, Destination: 0.0.0.0/0, Description: HTTP web access
                - Type: Custom TCP, Protocol: TCP, Port: 80, Source: Anywhere, Destination: ::/0, Description: HTTP web access
           - Hit Create security group
        3. Attach it to the web01-SG to allow ELB traffic
             - Go to Instances > web01 > Security > Security groups > web01-SG > Edit inbound rules
                 - Add rule
                   - Type: HTTP, Protocol: TCP,  Port range: 80, Source: Custom: web-elb-SG,  Description - optional: Load balancer access
                 - Hit Save rules   
        4. Create Load Balancer
           - Go to Load Balancing > Load balancers > Create load balancer
             - Load balancer types > Application Load Balancer
               - Hit Create
               - Load balancer name
                 - vpro-web-elb
               - Network mapping
                 - VPC
                   - vprofile-VPC
                 - Availability Zones
                   - select us-west-1a (usw1-az1)
                     - vpro-pubsub1
                   - select us-west-1b (usw1-az2)
                     - vpro-pubsub2
                   - Security groups
                     - web-elb-SG
                   - Protocol: HTTP, Port: 80, Default action: vpro-web-server-TG
             - Hit Create load balancer
        5. Open the Load balancer DNS end point to check
            - Go to Load balancers > vpro-web-elb > DNS name
              - Copy the URL and paste it in the browser
        6. Clean up
            - Delete Load Balancer
            - Terminate instances
            - Delete NAT Gateway
            - Release Elastic IP
   19. VPC Peering
       
       In production environment, you may have a number of VPCs, one for DBS, for APIs, maybe one for Web Servers, etc. To connect all these VPCs you need to setup VPC peering.

       1. Go to US West(Oregon) region > Create VPC 
            - Resources to create
              - VPC only
            - Name tag - optional
              - vpro-db
            - IPv4 CIDR
              - 172.21.0.0/16
          - Hit Create VPC
          - Go to Route tables
            - Select the vpro-db VPC and name the route table, "vprodb-RT"
       2. VPC peering setup in California Region (Requester)
          - Go to N.California > VPC > Peering connections > Create peering connection
            - Name - optional
              - vpro-NC-peering
                - Select a local VPC to peer with
                  - vprofile-VPC
                - Select another VPC to peer with > Account
                  - My account
                - Region
                  - Another Region
                    - US West (Oregon) (us-west-2)
                - VPC ID (Accepter)
                  - Paste Oregon's VPC ID in the field
                - Hit the Create peering connection
       3. Go to Oregon Region to accept the request
             - Virtual private cloud > Peering connections > Click on the link > Actions > Accept request > Accept request
       4. In N.California Region, add a rule to allow Oregon VPC network
            - Go to VPC > Route tables > vpro-priv-RT > Routes > Edit routes
              - Hit Add rule
                - Destination: 172.21.0.0/16
                - Target: Peering connection
                  - vpro-NC-peering
              - Hit Save changes
       5. In Oregon region, add a rule to allow California VPC network traffic (172.20.0.0/16)
            - Go to VPC > Route tables > vprodb-RT > Routes > Edit routes
              - Hit Add rule
                - Destination: 172.20.0.0/16
                - Target: Peering connection
                  - vpro-NC-peering
              - Hit Save changes
       6. To allow SSH from California region to Oregon region
            - Go to EC2 > Security groups > security-group-name > Inbound rules > Edit
              - Add rule
                - Type: SSH, Protocol: TCP, Port range: 22, Source: Custom (172.20.0.0/16) or specific subnet (172.20.1.0/24) or specific IP (172.20.1.25/32)
       7.  Clean up
           - Delete VPCs in Oregon and California Regions  
6. Automatic VPC Creation
   - Hit the Create VPC > VPC and more
   - Name tag auto-generation
     - "vprofile"
   
   - Pv4 CIDR block
     - 172.20.0.0/16
   
   - Tenancy
     - Default
   
   - Number of Availability Zones (AZs)
     - 2
   
   - Customize AZs
     - us-west-1a
     - us-west-1b
   
   - Number of public subnets
     - 2
   - Number of private subnets
     - 2
   
   - Customize subnets CIDR blocks
     - 172.20.1.0/24
     - 172.20.2.0/24
     - 172.20.3.0/24
     - 172.20.4.0/24

   - NAT gateways ($)
     - 1 per AZ
  
   - VPC endpoints
     - s3 Gateway
   - Hit the Create VPC
   - Clean up
     - Delete the VPC
  
  ### Logs Management

  When users access a site, the logs are created and in no time the server may run out of space due to large amount of logs, especially if the site is public facing and there is a lot of traffic to it. The solution is to ship the logs outside the server and periodically clean the logs from the web server.

  #### 1. Create a Webserver
  
  - In EC2 console click on Launch instance
    - Launch an instance
      - Name and tags
            - Name: "Barista-Cafe-Web01"
          - Application and OS Images (Amazon Machine Image)
            - Search for Amazon Linux 2 AMI
          - Instance type
            - t2.micro
          - Key pair(login)
            - Create new key pair
              - "Barista-Cafe-Key"
          - Network Settings > Edit
            - Firewall(security group)
              - Create security group
                - Named, "barista-cafe-SG"
              - Description
                - Enter "barista-cafe-SG"
            - Inbound Security Group Rules
              Set notifications
              
              Rule 1
                - Type: "ssh", Protocol: "TCP", Port range: 22
                - Source type: "My IP", Name: YOUR IP, Description: *optional* 
              
              Rule 2
                - Type: "Custom TCP", Protocol: "TCP", Port range: 80
                - Source type: "Anywhere", Source: "0.0.0.0/0", Description: "HTTP Web Access"
          - Scroll all the way down to Advanced details > User data - optional 
            - Paste [this](barista-cafe.sh) bash script code
    - Hit the Launch instance button

  #### 2. Create an EC2 role
  - Go to IAM > Roles > Create role
    - Select AWS service
    - Service or use case
      - EC2
    - Hit Next
    - Permissions policies 
      - Search for Cloud Watch and s3
        - Check CloudWatchLogsFullAccess and AmazonS3FullAccess
    - Hit Next
    - Role name
      - log-admin-role
    - Description
      - System EC2 service admin role to fetch logs from the Webserver

  #### 2. Attach permissions policy the Webserver

  - Go to EC2 > Actions > Security > Modify IAM role > log-admin-role
  - Update IAM role

  #### 3. Install AWS cli on the server

    ssh -i "Barista-Cafe-Key.pem" ec2-user@webserver-public-ip
    sudo yum install awscli -y

  Connect to AWS account

    aws configure

  Remove the aws credentials so you can only use the service role

    rm -rf .aws/credentials

  #### 4. Install Cloud Watch Agent in the Webserver

    sudo yum install awslogs -y
    sudo vim /etc/awslogs/awslogs.conf

    sudo ls /var/log/messages
    sudo ls /var/log/httpd/access_log

  Create System Logs and Access Log like so;

    [/var/log/messages]
    datetime_format = %b %d %H:%M:%S
    file = /var/log/messages
    buffer_duration = 5000
    log_stream_name = barista-cafe01-sys-logs
    initial_position = start_of_file
    log_group_name = /var/log/messages


    [/var/log/httpd/access_log]
    datetime_format = %b %d %H:%M:%S
    file = /var/log/httpd/access_log
    buffer_duration = 5000
    log_stream_name = barista-cafe01-httpd-access
    initial_position = start_of_file
    log_group_name = barista-cafe

  Restart AWS logs service

    sudo systemctl restart awslogsd
    sudo systemctl enable awslogsd

  Verify in Cloudwatch
/var/log/httpd/access_log
  - Go to CloudWatch > Logs > Log groups > barista-cafe > barista-cafe01-httpd-access

To specifically only send /var/log/httpd/access_log logs

  Update it like so
  
    [/var/log/messages]
    datetime_format = %b %d %H:%M:%S
    file = /var/log/messages
    buffer_duration = 5000
    log_stream_name = barista-cafe01-sys-logs
    initial_position = start_of_file
    log_group_name = /var/log/messages


    [/var/log/httpd/access_log]
    datetime_format = %b %d %H:%M:%S
    file = /var/log/httpd/access_log
    buffer_duration = 5000
    log_stream_name = barista-cafe01-httpd-access_log
    initial_position = start_of_file
    log_group_name = barista-cafe

  Restart AWS logs service

    sudo systemctl restart awslogsd
    sudo systemctl enable awslogsd
  
  #### Cloud Watch Metric Filters

  You can create Metric filters for different filters, examples can be found [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/MonitoringPolicyExamples.html).

  #### Retrieving logs from Load Balancer

  1. Create an s3 bucket and a folder named elb-barista-cafe inside it.
     - Go to Create bucket > Bucket name > unique-bucket-name > Create bucket
     - Open the bucket and create a folder inside it named elb-barista-cafe    
     - Go to unique-bucket-name > permissions > Bucket policy > Edit
       - Copy the policy [example code](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy) provided and edit it accordingly
       - It should be similar to [this](s3-elb-bpolicy.json)
        
     Replace elb-account-id with the ID of the AWS account for Elastic Load Balancing for your Region.

  2. Go to EC2 > Load balancers > Create load balancer > Application Load Balancer
     - Hit Create
     - Load balancer name
       - Barista-cafe-ELB
       - Network mapping
         - VPC
           - Leave default
         - Availability Zones
           - Select all
       - Security groups
           - Barista-cafe-SG
       - Listeners and routing  > Default action > Create target group
         - Barista-cafe-TG
       - Hit Create target group
         - Check the Barista-Cafe-Web01
         - Hit Include as pending below
       - Hit Create target group
       - Go back to Listeners and routing
         - Select Barista-cafe-TG under Default action
       - Hit Create load balancer
     - Go to Load balancers > Barista-cafe-ELB > Attributes > Monitoring
       - By default it's off
       - Enable by clicking on Edit button
       - S3 URI
         - Paste the path to the folder
     - Hit Save changes
     - After some time you should be able to see ELB logs
  

  # References

  1. [AWS Skills Builder](https://explore.skillbuilder.aws/learn?trk=8c070e03-5a8e-483f-b766-a157430938d6~ha_awssm-10292_tnc&sc_icampaign=aware_digitaltraining_skillbuilder_signin_mar_tnc_global_traincert_100-dl&sc_ichannel=ha&sc_icontent=awssm-10292_tnc&sc_iplace=signin)
  2. [Subnet calculator](https://jodies.de/ipcalc)
  3. [SmartDraw Diagramming](https://www.smartdraw.com/buy/)
  4. [Draw.io Diagramming](https://app.diagrams.net/)
