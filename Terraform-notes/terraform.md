# Terraform

- Terraform is an IAAC | Automate Infrastructure
- Defines Infrastructure State
  - For example; AWS instance, Security Group, Load Balancer, RDS, Beanstalk etc. Terraform makes sure it stays in the same state.
- Ansible, puppet or chef automates mostly OS related tasks
  - Defines machines state
    - State of the OS; what packages should be installed, what version, what configuration file. 
- The above mentioned tools can be used as well but they don't manage the state of the infrastructure
- Terraform automates infra itself and also maintain its state
  - Like AWS, GCP, AZURE, digitalOcean. etc
- Terraform works with automation softwares like Ansible after infra is setup and ready. For example, you provision EC2 instance, you launch them with Terraform, you then automate the provisioning with Ansible i.e. installing applications, packages etc
- No programming, its own syntax called Domain Specific Language similar to JSON


## Installation Requirements

1. Just download a Terraform binary from its website
    
   - Linux
   - Mac
   - Windows
2. Store the binary in exported PATH e.g Linux

        /usr/local/bin

    For Windows you can use Choco

        choco install terraform

## Launch an EC2 Instance with Terraform

**Prerequisites**

- AWS Account
- IAM User with access keys
- Terraform file to launch instance
- Run ```terraform apply```

**Exercise One - Deploying an EC2 instance to AWS**

- Write ```instance.tf``` file
- Launch instance
- Make some changes to the ```instance.tf``` file
- Apply changes 
  
If the state is different from the current one, only then will it apply the changes.

**Steps**
1. Download terraform for your OS [here](https://developer.hashicorp.com/terraform/install?product_intent=terraform)

2. Check the version

       $ terraform version

   Output

       Terraform v1.9.5
       on linux_amd64

3. Install AWS CLI, instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and check version

       $ aws --version

4. Create an IAM user

    - Go to IAM > Users > Create user > User name: ```terradmin```
    - Hit Next
    - Permissions options
      - Select *Add user to group* > your preferred group
    - Hit Next then hit Create user
    - Go to terradmin > Create access key > Select *Use case* as Command Line Interface (CLI) and check the Confirmation box
    - Hit Next 
    - Create access key
    - Download .csv file
    - Hit Done

5. Log into your AWS

        $ aws configure

   Output

        AWS Access Key ID [****************ZBO4]: your-key-ID-here
        AWS Secret Access Key [****************mHI2]: your-access-key-here
        Default region name [us-east-1]: your-region-here
        Default output format [json]: json

6. Create a key pair
   
   Go to EC2 > Network & Security > Key Pairs > Create key pair

    - Name: ```dove-key``` 
    - Hit Create key pair
   
   Change key permissions

        $ chmod "400" ~/Downloads/dove-key
  
7. Create a security group named ```dove-SG```

   Go to EC2 > Network & Security > Security Groups 
   - Basic details > Security group name: ```dove-SG```
   - Inbound rules > Add rule
   - Type: ```SSH``` Protocol: ```TCP``` Port range: ```22```
   - Source type: ```myIP``` Source: ```Your-IP-here``` Description - optional: ```EC2 Terraform SSH access```
   - Type: ``HTTP`` Protocol: ``TCP`` Port range: ``80``
   - Source type: ``Anywhere-IPv4`` Source: ``0.0.0.0/0`` Description - optional: ``Web Access From Anywhere``
   - Hit Create security group
   - Copy ```Security group ID``` and paste it under ``vpc_security_group_ids`` in ``resource`` section of ``first-instance.tf`` file

8. Create a directory for your terraform

        $ ~/cd /Documents
        $ mkdir terraform-scripts && cd terraform-scripts
        $ mkdir exercise1 && cd exercise1
        $ vim first-instance.tf

9. Paste the code of the ``first-instance.tf`` [file](./exercise-01/first-instance.tf) and save it
10. Run ``terraform init`` command to check AWS provider, download AWS plugins into the current working directory

    Run ``ls -la`` to confirm

    Output

        $ drwxr-xr-x 3 mbadwa mbadwa 4096 sep 20 20:52 .terraform

    Validate the terraform ``first-instance.tf`` file to check if there are no errors

        $ terraform validate

    Output

        ╷
        │ Error: Invalid reference
        │ 
        │   on first-instance.tf line 9, in resource "aws_instance" "terra_intro":
        │    9:   key_name = dove-key
        │ 
        │ A reference to a resource type must be followed by at least one attribute access, specifying the resource name.

    The ``dove-key`` is not in double quotes hence the error

    When successful the message is this: ``Success! The configuration is valid.``

11. Format the style by running the ``fmt`` command
    

    To compare and contrast the formats

        $ cat first-instance.tf

    Output

        provider "aws" {
        region = "us-east-1"
        } 

        resource "aws_instance" "terra_intro" {
        ami = "ami-0ebfd941bbafe70c6"
        instance_type = "t2.micro"
        availability_zone = "us-east-1a"
        key_name = "dove-key"
        vpc_security_group_ids = ["sg-05240e7b1f709ac75"]
        tags = {
            Name = "Dove-instance"
        }
        }

    Format

        $ terraform fmt

    Output

        first-instance.tf

    Check the formatted file

        $ cat first-instance.tf

    Output

        provider "aws" {
        region = "us-east-1"
        }

        resource "aws_instance" "terra_intro" {
        ami                    = "ami-0ebfd941bbafe70c6"
        instance_type          = "t2.micro"
        availability_zone      = "us-east-1a"
        key_name               = "dove-key"
        vpc_security_group_ids = ["sg-05240e7b1f709ac75"]
        tags = {
            Name = "Dove-instance"
        }
        }    
   
12. The ``terraform plan`` command gives you a preview what will be done before applying any changes

    Run 

        $ terraform plan

    Output is lengthy

        Terraform used the selected providers to generate the following execution plan.....
        .
        .
        .
        .
        Plan: 1 to add, 0 to change, 0 to destroy.

    Apply

        $ terraform apply
Destroy complete! Resources: 1 destroyed.

    Check the EC2 in the console, it should be running

13. Make minor change the ``first-instance.tf`` file

        $ vim first-instance.tf

    Add a tag under ``tags`` and save

        Project = "Dove"

14. Validate and format the ``first-instance.tf`` file

    Validate

        $ terraform validate

    Output

        Success! The configuration is valid.

    Format

        $terraform fmt
15. Plan and Apply

    Plan

        $ terraform plan

    Output, lengthy

        Terraform used the selected providers to generate the following execution plan.....

    Apply

        $ terraform apply

    Output, lengthy

        Terraform used the selected providers to generate the following execution plan.....
        .
        .
        .
        .
        Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

16. Terraform compares current state with remote state, if there are changes locally then it'll apply the changes to the remote resource. Here is how it does it.

    Check the file ``terraform.tfstate`` file

        $ cat terraform.tfstate

    The output displays all attributes of the created resource

        {
         "version": 4,
         "terraform_version": "1.9.6",
         "serial": 1,
         "lineage": "90a341fe-3a25-688f-c59c-af0a10a51a67",
         "outputs": {},
            .
            .
            .
            .
          "check_results": null
        }


17. Terraform destroy reads the current state and ask for confirmation

    Run ``terraform destroy`` and confirm with a ``yes `` to proceed


    Output, lengthy

        Terraform used the selected providers to generate the following execution plan.....
        .
        .
        .
        .
        Destroy complete! Resources: 1 destroyed.

**Exercise two - Terraform Variables**

This focuses on how to define variables and how to consume them. Variables will help with;

- Move secrets to another file
- Values that changes based on environment, you can change them using variables. For example AMI, tags, keypair etc.
- Reuse your code for example in dev, test and prod environments or reusing it in other projects

Providers section has value region in ``instance.tf`` in exercise one, it's called ``first-instance.tf`` of course. That will be moved to ``vars.tf`` in the provider will be called as a variable

    provider "aws" {
        region = va.REGION
    }

The variables file ``vars.tf`` will look like so

    variable AWS_REGION {
        default = "us-west-1"
    }

The keys variables will be in ``terraform.tfvars``

    AWS_ACCESS_KEY = ""
    AWS_SECRET_KEY = ""

Not recommended practice for security reasons

The ``instance.tf`` file will look 

    resource "aws_instance" "intro" {
        ami = "ami-0ebfd941bbafe70c6"
        instance_type = "t2.micro"
    }

The ``vars.tf`` will include the variable keys and AMIs 

    variable AWS_ACCESS_KEY {}
    variable AWS_SECRET_KEY {}
    variable REGION {
        default = "us-east-1"
    }

    variable AMIS [
        type = "map"
        default {
            us-east-1 = "ami-0ebfd941bbafe70c6"
            us-east-2 = "ami-037774efca2da0726"
        }
    ]

The ``instance.tf`` will include region variables

    resource "aws_instance" "intro" {
        ami = var.AMIS[var.REGION]
        instance_type = "t2.micro"
    }

**Tasks**

- Write a ``providers.tf`` file
- Write a ``vars.tf`` file
- Write an ``instance.tf`` file
- Validate then Apply Changes
- Make some changes to ``instance.tf`` file
- Revalidate and Reapply the changes

**Steps**

1. Create a ``providers.tf`` [file](./exercise-02/providers.tf)
2. Create a ``vars.tf`` [file](./exercise-02/vars.tf)
3. Create an ``instance.tf`` [file](./exercise-02/instance.tf)
4. Run ``terraform init`` to initialize Terraform

   output

        Initializing the backend...
        .
        .
        .
        .
        Terraform has been successfully initialized!

5. Run ``terraform validate`` to validate the config files

   Output

        Success! The configuration is valid.
6. Run ``terraform fmt`` to format the files

   Output

        instance.tf
        vars.tf

7. Print ``instance.tf`` file to the terminal 

        cat instance.tf

   Output

        resource "aws_instance" "dove-instance" {
            ami                    = var.AMIS[var.REGION]
            instance_type          = var.INSTANCE_TYPE
            availability_zone      = var.ZONE1
            key_name               = "dove-key"
            vpc_security_group_ids = ["sg-05240e7b1f709ac75"]
            tags = {
                Name    = "Dove-instance"
                Project = "Dove"
            }
        }

8. Print ``vars.tf`` file to the terminal 


        cat vars.tf

   Output

        variable "REGION" {
        default = "us-east-1"
        }

        variable "ZONE1" {
        default = "us-east-1a"
        }

        variable "AMIS" {
        description = "ID of AMIs to use for the instance"
        type        = map(any)
        default = {
            us-east-1 = "ami-0ebfd941bbafe70c6"
            us-east-2 = "ami-037774efca2da0726"
        }
        }

        variable "INSTANCE_TYPE" {
        description = "The type of instance to start"
        type        = string
        default     = "t2.micro"
        }
9. Dry run

        terraform plan
   
   Output

        Terraform used the selected providers to generate the following execution plan.
        .
        .
        .
        .
        Plan: 1 to add, 0 to change, 0 to destroy.

10. Apply 

        terraform apply

    Output

        
        Terraform used the selected providers to generate the following execution plan.
        .
        .
        .
        .
        Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
11. Clean up

        terraform destroy

    Output

        aws_instance.dove-instance: Refreshing state... [id=i-04a514198333e7eda]
        .
        .
        .
        .
        Destroy complete! Resources: 1 destroyed.

## Terraform Manual Managed Provisioning in AWS

**Provisioning use cases**

1. You use provisioning to build custom images with tools like **Packer**
2. Use standard image and use provisioner to setup softwares and files.
   - Upload files or artifacts
   - ``remote_exec``
     - Ansible, Puppet or Chef

**Provisioner Connection**

SSH for Linux

    provisioner "file" {
        source = "files/test.conf"
        destination = "/etc/test.conf"

        connection {
            type = "ssh"
            user = "root"
            password = var.root_password
        }
    }

WinRM for Windows


    provisioner "file" {
        source = "conf/myapp.conf"
        destination = "C:/App/myapp.conf"

        connection {
            type = "winrm"
            user = "Administrator"
            password = var.admin_password
        }
    }

**More Provisioners**

- The **file** provisioner is used to copy files or directories
- **remote-exec** invokes a command/script on remote resource
- **local-exec** provisioner invokes a local executable after a resource is created
- The **puppet** provisioner installs, configures and runs the Puppet agent on a remote resource
  - Supports both **ssh** and **winrm** type connections

- Ansible: run terraform, Output IP address, run playbook with **local-exec**

You need a few things, e.g. 

**Variables**

    variable "PRIV_KEY_PATH" {
        default = "infi-inst_key"
    }

    variable "PUB_KEY_PATH" {
        default = "infi-inst_key.pub"
    }

    variable "USER" {
        default = "ubuntu"
    }

**Key Pair & Instance Resources**


    resource "aws_key_pair" "dove-key" {
        key-name = "dovekey"
        public_key = file("dovekey.pub")
    }


    resource "aws_instance" "intro" {
        ami = var.AMIS[var.REGION]
        instance_type = "t2.micro"
        availability_zone = var.ZONE1
        key_name = aws_key_pair.dove-key.key_name
        vpc_security_group_ids = ["sg-833e24fd"]
    }

**File Provisioner**

    provisioner "file" {
        source = "web.sh"
        destination = "/tmp/web.sh"
    }

        connection {
            user = var.USER
            private_key = file(var.PRIV_KEY_PATH)
            host = self.public_ip
        }

**Remote-exec Provisioner**

    provisioner "remote-exec" {
        inline = [
            "chmod u+x" /tmp/web.sh
            "sudo /tmp/web.sh"
        ]
    }

**Exercise three - push a script with Terraform**

**Tasks**

- Generate key pair
- Create script
- Create ``providers.tf``
- Create ``vars.tf``
- Create ``instance.tf``
  - key pair resource
  - aws_instance resource
    - provisioners 
      - file
      - remote-exec
- Apply changes
  
**Steps**

1. Create an SSH key in exercise-03 directory

        $ cd ~/Documents/terraform-scripts
        $ mkdir exercise-03 && cd exercise-03
        $ ssh-keygen
        $ Enter file in which to save the key (/root/.ssh/id_rsa): dovekey
        $ ls

    NOTE: You should have a public key and a private key in the current folder ``exercise-03``
2. Create a script named ``web.sh`` and paste the [code](./exercise-03/web.sh)

        $ sudo vim web.sh
        $ esc
        $ :wq!

3. Create a provider file named ``providers.tf`` and paste the [code](./exercise-03/provider.tf)

        $ sudo vim providers.tf
        $ esc
        $ :wq!

4. Create a file named ``vars.tf`` and paste the [code](./exercise-03/vars.tf)

        $ sudo vim vars.tf
        $ esc
        $ :wq!

5. Create a file named ``instance.tf`` and paste the [code](./exercise-03/instance.tf)
   
        $ $ sudo vim vars.tf
        $ esc
        $ :wq!

6. Initialize Terraform

        $ terraform init

7. Terraform validate for syntax 
   
        $ terraform validate

8. Terraform format

        $ terraform fmt

9.  Terraform plan

        $ terraform plan

10. Terraform apply
   
        $ terraform apply

11. Destroy the resources

        $ terraform destroy

**Exercise Four - Output**

- When we run ``terraform apply`` it retains a lot of output that gets stored in ``terraform.tfstate`` file. Information from it can be accessed directly, for example you can fetch info of an instance, ``aws_instance`` and get the **attribute** ``public_ip`` from it.
- The `` output`` block can be used to print the attributes
- The ``local-exec`` to save info such as IDs, IP addresses etc, into a text file

**Output Attributes**

    output "instance_ip_addr" {
        value = aws_instance.server.public_ip
    }

Elements => resourceType.resourceName.attributeName

    resourceType => aws_instance
    resourceName => Server
    attributeName => public_ip

**Store Output in a File**

    resource "aws_instance" "out_inst" {
        ami = ver.AMIS[var.REGION]
        instance_type = "t2.micro"
        key_name = aws_key_pair.dino-key.key_name
    

        provisioner "local-exec" {
            command = "echo aws_instance.out_inst.private_ip >> private_ips.txt"
        }

    }

**Print IPs as an Output**

To print output in the terminal after running the ``terraform apply`` command and use the information to access the server

**Steps**

- Copy the ``exercise-03`` folder and name it ``exercise-04`` folder

        $ cp -r exercise-03 exercise-04

- Update the ``instance.tf`` [code](./exercise-04/instance.tf) and add the output lines at the bottom

        $ sudo vim instance.tf
  
  Append these lines to it

        output "PublicIP" {
            value = aws_instance.dove-inst.public_ip
        }

        output "PrivateIP" {
            value = aws_instance.dove-inst.private_ip
        }

- Terraform Initialize

        $ terraform init

- Terraform Validate

        $ terraform validate

- Terraform format
        
        $ terraform fmt

- Terraform Plan

        $ terraform plan

    NOTE: In the output of ``terraform plan`` you can also list a number of attributes that Terraform will create for the resource

- Terraform Apply

        $ terraform apply

- Terraform Destroy
        
        $ terraform destroy

**Exercise Five - Backend**

The ``terraform.tfstate`` file keeps the current state locally in your machine, if the infrastructure is being maintained by a team, each will have a different file of ``terraform.tfstate`` representing their own changes to the infrastructure that will be different for everyone. To solve the this challenge, Terraform uses backend to sync all the states of each team member so that all local ``terraform.tfstate`` files are in sync to have the the same exact content.

**Steps**

- Copy the ``exercise-04`` folder and name it ``exercise-05`` folder

        $ cp -r exercise-04 exercise-05

- Create an S3 bucket [file](./exercise-05/backend.tf) and paste the content

        $ sudo vim backend.tf

- Create a folder inside the S3 bucket named `terraform`

- Execute Terraform

    Terraform Init

        $ terraform init

    Validation

        $ terraform validate

    Format

        $ terraform fmt

    Terraform Application

        $ terraform apply

    Deletion

        $ terraform destroy 

**Exercise Six - Multi Resource**

Terraform is used by different providers, e.g. DigitalOcean, Oracle, Alibaba etc. The featured providers are these [ones](https://registry.terraform.io/)

Let's go to ``aws_instance`` resource in the [documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

1. Create `exercise-06` directory and create a [file](./exercise-06/providers.tf) named `providers.tf` 
   
        $ mkdir exercise-06 && cd exercise-06
        $ vim providers.tf
2. Create a `vars.tf` [file](./exercise-06/vars.tf)
   
        $ vim vars.tf

3. Copy the ssh keys into the folder

        $ cp ~/Documents/terraform-scripts/exercise-05/terrakey .
        $ cp ~/Documents/terraform-scripts/exercise-05/terrakey.pub .
4. Create a VPC resource [file](./exercise-06/vpc.tf) named `vpc.tf`

        $ vim vpc.tf

5. Create a `backend.tf` file and paste [code](./exercise-06/backend.tf)

        $ vim backend.tf

6. Create `instance.tf` file and paste [code](./exercise-06/instance.tf)

        $ vim instance.tf

7. Create `secgrp.tf` file and paste [code](./exercise-06/secgrp.tf)

        $ vim secgrp.tf
8. Create a `web.sh` file and paste [code](./exercise-06/web.sh)

        $ vim web.sh

9.  Execute Terraform

    Terraform Init

        $ terraform init

    Validation

        $ terraform validate

    Format

        $ terraform fmt

    Terraform Application

        $ terraform apply

    Deletion

        $ terraform destroy

## AWS Elastic Kubernetes Service (EKS) Provisioning with Terraform

To avoid a complex task of managing Kubernetes yourself, you can opt for EKS that is managed by AWS itself. The advantages are you'll no longer be involved with the system admin work, in this case, you just pass simple info regarding the K8s cluster to be created such as node groups, and management will be taken care of. You can change capacity in a whim, scaling out or in a snap of fingers.

We will use [Terraform Modules](https://registry.terraform.io/browse/modules?product_intent=terraform) to create the AWS EKS cluster

**Steps**

1. Clone the GitHub repo code [here](https://github.com/hkhcoder/vprofile-project.git) and switch to EKS branch
2. Create a bucket and update the Terraform dependencies in the cloned repo's file named `terraform.tf`
3. Open the cloned folder `vprofile-project`, go through each file to familiarize yourself with the cluster you are going to create
4. Install and deploy EKS Terraform Cluster
   1. Initialize
    
            $ terraform init
   2. Validate

            $ terraform validate
   3. Format

            $ terraform fmt
   4. Plan
   
            $ terraform plan

   5. Apply

            $ terraform apply
   
5. Connect to the cluster using a `kubeconfig` file

   1. Create a kubeconfig file command to manage your 

            $  aws eks update-kubeconfig --region us-east-1 --name your-cluster-name
   2. View the kubeconfig file create
   
            $ cat /home/mbadwa/.kubconfig

   3. Run kubectl commands as usual

            $ kubectl get nodes
            $ kubectl get pods

6. Destroy the cluster

            $ terraform destroy
# References

1. [Terraform Featured Providers](https://registry.terraform.io/)
2. [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
3. [AWS Provider Code Snippet Guides](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
4. [Terraform Modules](https://registry.terraform.io/browse/modules?product_intent=terraform)
5. [AWS EKS Guide](https://docs.aws.amazon.com/eks/latest/userguide/network-reqs.html)