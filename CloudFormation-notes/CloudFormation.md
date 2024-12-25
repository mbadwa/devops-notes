# CloudFormation

IAAC (Infra As A Code) native to AWS

**Templates**

Templates are scripts or text files written in JSON or YAML format that CloudFormation takes in as an input to create infrastructure in AWS.

Describe the state of the infra in the templates

**Stack**

CloudFormation reads a Template and create a stack.

We update a template and update stack to make changes

It creates a set of resources as a single unit, input is the template and output is the stack

**Change Set**

Before updating a stack, you can generate a change set

A change set allows you to see how changes will impact your **existing** resources

This is very crucial for live environments. E.g. Renaming an RDS instance will 

- Create a new one 
- Delete old one along with the data

**Note:** This is similar to Terraform Plan in Terraform

### Template Anatomy

**Templates (JSON) Format**

        (
            "AWSTemplateFormatVersion": "version date",
            "Description": "String",
            "Metadata": "template metadata",
            "Parameters": {set of parameters},
            "Mappings": {set of mappings},
            "Conditions": {set of conditions},
            "Transform": {set of transforms},
            "Resources": {set of resources},
            "Outputs" : {set of outputs}
        )


**Templates (YAML) Format**

        AWSTemplateFormatVersion: "version date"
        Description: 
          String
        Metadata: 
          template metadata
        Parameters: 
          set of parameters
        Mappings: 
          set of mappings
        Conditions: 
          set of conditions
        Transform: 
          set of transforms
        Resources: 
          set of resources
        Outputs: 
          set of outputs

**Breakdown**

All sections are optional except for the **Resources** section

- AWSTemplateFormatVersion is the template version
- Description of the resource
- Metadata is more info about your template
- Parameters could be inputs like Keypair, selecting a security group. - Mappings of key:value pair store like a dictionary in Python or lookup table. 
- Conditions are conditions that CloudFormation will check if they are met a certain action takes place. 
- Transform are for AWS serverless application where AWS versions of SAM. 
- Resources such as EC2, VPC etc
- Outputs is for printing something out while creating the resources or after the resource is created.

**Resources Section (JSON)**

    {
        "Resources": {
            "Logical ID" : {
                "Type": "Resource type",
                "Properties": {
                    ... set of properties ..
                }
            }
        }
    }

**Resources Section (JSON)**

    Resources:
      Logical ID:
        Type: Resource Type
        Properties:
          ... set of properties

Section Breakdown

- Logical ID: is just a reference point to the resource not the actual name of the resource
- Resource type is simply the service you want to create, i.e. EC2, S3, RDS etc.
- Properties are the properties for the resource such as the key you want to use or encryption type you want to enable etc.

**EC2 Instance Resources Section (JSON)**

    {
        "Resources": {
            "MyFirstInstance" : {
                "Type": "AWS::EC2::Instance",
                "Properties": {
                    "ImageId": "ami-6789231"
                    "InstanceType" : "t2.micro"
                }
            }
        }
    }

**EC2 Instance Resources Section (YAML)**

    Resources:
      MyFirstInstance:
        Type: "AWS::EC2::Instance"
        Properties:
          ImageId: "ami-6789231"
          InstanceType: t2.micro


**S3 Resources Section (YAML)**

    Resources:
      MyS3Bucket:
        Type: "AWS::S3::Bucket"
        Properties:
          BucketName: chamomile
          AccessControl: PublicRead
          WebsiteConfiguration:
            IndexDocument: index.html

**SG Resources Section (YAML)**

    Resources:
      MySG:
        Type: "AWS::EC2::SecurityGroup"
        Properties:
          GroupDescription: String
          GroupName: String
          SecurityGroupIngress:
            - IpProtocol: tcp
            - FromPort: 22
            - ToPort: 22
            - CidrIP: 0.0.0.0/0

### CloudFormation Resources Creation Examples

**1. Create a Simple EC2** 

     1. EC2
        - Create this YAML [file](./cformation_basics/first_example.yaml) 
        - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
          - Provide a stack name > Stack name: EC2-Stack
          - Parameters: Leave blank
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit

     3. Update Stack with a new Template

        - Create a new template [file](./cformation_basics/update_example.yaml)
        - Go to CloudFormation > Stacks > EC2-Stack > Update
        - Update stack > Prerequisite - Prepare template > Replace existing template
        - Specify template > Template source > Upload a template file
        - Hit Next > Next > Next > Next
        - Submit

     4. Clean up 
   
        - Go to CloudFormation > Stack > `EC2-Stack`
        - Hit Delete

**2. Create a Simple EC2 with function**

    1. EC2 with Function
        - Create this YAML [file](./cformation_basics/functions.yaml) 
        - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
         - Provide a stack name > Stack name: `func-join`
         - Parameters: Leave blank
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit

    2. Clean up 
   
        - Go to CloudFormation > Stack > `func-join`
        - Hit Delete

**3. Change Set**
    
    1. Implementing a Change Set
        - Create a new [file](./cformation_basics/change-set.yaml) 
        - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
          - Provide a stack name > Stack name: `ChangeSet`
          - Parameters: Leave blank
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit
        - Change the Tags Value to `new-name`
        - Hit Update

    2. Clean up 
      
        - Go to CloudFormation > Stack > `new-name`
        - Hit Delete

**4. CloudFormation Pseudo Functions**
    
    1. Pseudo Functions
        - Create this YAML [file](./cformation_basics/Ref-function.yaml) 
        - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
          - Provide a stack name > Stack name: `pseudo-ref-func`
          - Parameters: Leave blank
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit
    2. Clean up 
      
        - Go to CloudFormation > Stack > `pseudo-ref-func`
        - Hit Delete

**5.  Creating a multi resource**
    
    1. Multi-Resource
        - Create a multi-resource [file](./cformation_basics/multiResource.yaml)

        - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
          - Provide a stack name > Stack name: `multiResource`
          - Parameters: Leave blank
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit

    2.  Clean up 
       
        - Go to CloudFormation > Stack > `multiResource`
        - Hit Delete

**6. Mappings and Pseudo Parameters**
   
   1. Mappings & Pseudo
        - Create a multi-resource [file](./cformation_basics/MappingsAndPseudoParams.yaml)

        - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
          - Provide a stack name > Stack name: `MapPseudo`
          - Parameters: Leave blank
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit

   2.  Clean up 
       
        - Go to CloudFormation > Stack > `MapPseudo`
        - Hit Delete

**7. Input Parameters**
   
   1. Create Key pairs named `input-key-1` and `input-key-2`
   2. Create a template [file](./cformation_basics/inputParameters.yaml)
   3. Input Parameters 
       - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
          - Provide a stack name > Stack name: `InputParameters`
          - Parameters:
            - Select the EC2 Type
            - Select a key
            - Give it a name
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit
   4.  Clean up 
        - Go to CloudFormation > Stack > `InputParameters`
        - Hit Delete 

**8. Print Outputs**
   1. Create a template [file](./cformation_basics/PrintOutputs.yaml) 
   2. Printing Outputs
       - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
          - Provide a stack name > Stack name: `PrintOutputs`
          - Parameters:
            - Select the EC2 Type
            - Select a key
            - Give it a name
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit
   4.  Clean up 
        - Go to CloudFormation > Stack > `PrintOutputs`
        - Hit Delete 
**9. Metadata** 

   1. Create a template [file](./cformation_basics/init.yaml)
   2. Init Metadata
       - Go to AWS > CloudFormation > Stacks > Create stack
        - Prerequisite - Prepare template > Prepare template > Template is ready
        - Specify template > Template source > Upload a template file > Upload a template file > Choose file
        - Hit Next
        - Specify stack details 
          - Provide a stack name > Stack name: `InitMetadata`
          - Parameters:
            - Select the EC2 Type
            - Select a key
            - Give it a name
        - Hit Next
        - Leave everything default and hit Next
        - Review and Create > Hit Submit
   4.  Clean up 
        - Go to CloudFormation > Stack > `InitMetadata`
        - Hit Delete 

# References

1. [AWS CloudFormation EC2 Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-eip.html)
2. [AWS General Services Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-eip.html)
3. [CloudFormation Pseudo Parameters](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/pseudo-parameter-reference.html)
4. [CloudFormation Resources List Documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-securitygroup.html)
5. [Mappings and Pseudo Parameters](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/mappings-section-structure.html)
6. [CloudFormation Parameters](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html)
7. [CloudFormation Outputs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html)
8. [CloudFormation Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-instance.html)
9. [CloudFormation Metadata](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html)
10. [Unresolved tag: !Ref in CloudFormation Template](https://github.com/redhat-developer/vscode-yaml/issues/669)