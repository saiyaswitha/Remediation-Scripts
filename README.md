# Remediation-Scripts
Create a remediation script for defined use cases using Ansible or Terraform. Create your own aws account (free tier) for development and testing.

**Remediation use case problem statement**
 - EKS control plane logging is enabled for your Amazon EKS clusters.

**Remediation resource** - AWS EKS
Resource metadata / parameter / factor  - logging enabled
**why remediation?** -
This remediation is useful for audit and logging purpose. Please refer to the below document for more details.
https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html

**Remediation or solution steps **- 

1. Create an EKS cluster
2. Configure "control plane logging" while craeting the cluster.
3. Destry once we have done testing 


**Roles and Permissions required for the IAM user to execute the remediation.** - 
 The IAM role which is attached to the cluster need to have below AWS managed policies attached:

 1. AmazonEKSVPCResourceController
 2. AmazonEKSServiceRolePolicy
 3. AmazonEKSClusterPolicy

An IAM user or AIM role would need minimum below permissions to view the EKS cluster.

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:ListFargateProfiles",
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:ListUpdates",
                "eks:AccessKubernetesApi",
                "eks:ListAddons",
                "eks:DescribeCluster",
                "eks:DescribeAddonVersions",
                "eks:ListClusters",
                "eks:ListIdentityProviderConfigs",
                "iam:ListRoles"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ssm:GetParameter",
            "Resource": "arn:aws:ssm:*:111122223333:parameter/*"
        }
    ]
} 


**Reference to the backlog / use-case id in spreadsheet -**
**Ref**: Slide 4 and Step -3 from the presentation.

**How to setup the infrastructure for testing? - **

All the code for creating the infrastructure including the remdiation is included in below "eks_logging_test.tf" file and the process to run the code is exaplined below. Please follow the same.

**How to run the script? or How to execute the command?**

**Pre requisites: **
1. an AWS account with the IAM permissions listed on the EKS module documentation,
2. a configured AWS CLI
3. AWS IAM Authenticator
4. kubectl
5. wget (required for the eks module)

**AWS CLI installation:**

In order for Terraform to run operations on your behalf, you must install and configure the AWS CLI tool. To install the AWS CLI, follow these instructions or choose a package manager based on your operating system.

**For Windows:**

choco install awscli

**For MacOS:**

brew install awscli

After you've installed the AWS CLI, configure it by running aws configure.

When prompted, enter your AWS Access Key ID, Secret Access Key, region and output format.

aws configure

AWS Access Key ID [None]: YOUR_AWS_ACCESS_KEY_ID

AWS Secret Access Key [None]: YOUR_AWS_SECRET_ACCESS_KEY

Default region name [None]: YOUR_AWS_REGION

Default output format [None]: json


If you don't have an AWS Access Credentials, create your AWS Access Key ID and Secret Access Key by navigating to your service credentials in the IAM service on AWS. Click "Create access key" here and download the file. This file contains your access credentials.

**Set up and initialize your Terraform workspace**

In your terminal, clone the following repository. It contains the example configuration used in this tutorial.

$ git clone https://github.com/hashicorp/learn-terraform-provision-eks-cluster

You can explore this repository by changing directories or navigating in your UI.

$ cd learn-terraform-provision-eks-cluster


**Initialize Terraform workspace**
Once you have cloned the repository, initialize your Terraform workspace, which will download and configure the providers.

**Step:1 **- $ terraform init
Initializing modules...
.....

**Provision the EKS cluster**
In your initialized directory, run terraform apply and review the planned actions. Your terminal output should indicate the plan is running and what resources will be created.

**Step:2** - $ terraform plan 

An execution plan has been generated and is shown below.

Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)
.
.
.


**Apply the changes:**

**Step:3** - $ terraform apply -auto-approve


This process should take approximately 10 minutes. Upon successful application, your terminal prints the outputs defined in outputs.tf.

**Clean up your workspace**

Remember to destroy any resources you create once you are done with this tutorial. Run the destroy command and confirm with yes in your terminal.

terraform destroy

**Details about the variables/parameters used ** 
Variables used are stored in "variables.tf" file.
region - Describes in which region you want the resources to be deployed in . Ex: us-east-2
cluster_name - Described the name of the EKS cluster name.
**Add file/folder details - names and purpose. - **
In here, you will find five files used to provision a VPC and an EKS cluster.

**vpc.tf** provisions a VPC, subnets and availability zones using the AWS VPC Module. A new VPC is created for this test 

**terraform.tf** sets the Terraform version to at least 0.14. It also sets versions for the providers used in this sample which is AWS.

**variables.tf** has all the variables configured which will be used in this test.

**outputs.tf** defines the output configuration.

**eks-logging.tf** provisions all the resources required to set up an EKS cluster using the AWS EKS Module with Control plane logging enabled.

**Any relevant reference can be added to the readme.md -**

https://learn.hashicorp.com/tutorials/terraform/eks?_ga=2.132343950.1627838959.1654479852-611053124.1649784627
