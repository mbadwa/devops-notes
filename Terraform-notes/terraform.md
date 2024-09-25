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

## Terraform Provisioning