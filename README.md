Creating an Amazon EKS Cluster with Custom Configuration using Terraform

This guide walks you through the process of using Terraform to create an Amazon EKS cluster with custom configurations. This cluster will include custom networking, cluster settings, and a node group. Additionally, you'll learn how to use a remote state backend for managing your Terraform state files.

Prerequisites

Before you begin, make sure you have the following:

An AWS account
Terraform installed (version X.XX.X or higher)
AWS CLI installed and configured with necessary permissions
Basic understanding of Terraform and Amazon EKS
Getting Started

Clone this repository:
git clone https://github.com/minaezzat0/EKS-Cluster-Terraform.git

Navigate to the cloned directory:
cd Eks-cluster


Configure your AWS credentials using the AWS CLI:
aws configure


Modify variables.tf to customize your EKS cluster settings:

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
}

variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}


# Add more variables as needed
Edit Credentials.tf to configure the AWS provider with your custom credentials:

provider "aws" {
  shared_config_files      = ["/path/to/your/aws/config"]
  shared_credentials_files = ["/path/to/your/aws/credentials"]
  profile                  = "default"
}
Replace /path/to/your/aws/config and /path/to/your/aws/credentials with the actual paths to your AWS configuration and credentials files.


Modify vars-auto.tfvars to pass the desired variable values:

vpc_cidr_block             = "10.0.0.0/16"
public_subnets_cidr_block  = ["10.0.1.0/24"]
private_subnets_cidr_block = ["10.0.2.0/24"]
Azs                        = ["us-east-1a", "us-east-1b"]
ingress_ports              = [22]
ingress_cidr_block         = "0.0.0.0/0"
egress_ports               = [-1]
egress_cidr_block          = "0.0.0.0/0"
Eks_instance_types         = ["t3.micro"]
Customize these values according to your networking and node group requirements.



Using Remote State Backend

Create a new S3 bucket for storing your Terraform state files and a DynamoDB table for state locking:

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-iti-remon-louis"
  acl    = "private"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-iti-dynamodb"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


Configure your backend.tf file to use the S3 bucket and DynamoDB table:

terraform {
  backend "s3" {
    bucket         = "terraform-iti-remon-louis"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-iti-dynamodb"
  }
}
Replace the values with your actual S3 bucket and DynamoDB table names.


Customizing the EKS Cluster Configuration

Networking Configuration
Open network.tf and customize the networking configuration as needed. For example, you can modify the VPC settings, subnet configurations, and security groups.
EKS Cluster Configuration
Open eks.tf and modify the EKS cluster settings according to your requirements. You can adjust the version, Kubernetes API server access settings, and more.
Node Group Configuration
Open nodegroups.tf to adjust the node group settings as desired. You can customize the instance type, desired capacity, max capacity, and other settings.


Deploying the EKS Cluster

Initialize the Terraform configuration:
terraform init

View the execution plan to ensure everything is set up correctly:
terraform plan -var-file=vars-auto.tfvars

Make sure to specify the vars-auto.tfvars file using the -var-file flag.

Apply the changes to create the EKS cluster:
terraform apply -var-file=vars-auto.tfvars

Again, specify the vars-auto.tfvars file using the -var-file flag.

Wait for the provisioning to complete. This might take a while as AWS provisions the resources.
Connecting to the EKS Cluster

Configure kubectl to use the newly created EKS cluster:
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

Verify your connection by listing the nodes:
kubectl get nodes

When you're finished with the EKS cluster, make sure to clean up the resources to avoid incurring unnecessary costs.

Destroy the Terraform resources:
bash
Copy code
terraform destroy -var-file=vars-auto.tfvars


Congratulations! You've successfully created an Amazon EKS cluster with custom configurations using Terraform. This guide covered only the basics; for more advanced configurations and additional features, refer to the official Terraform documentation and AWS documentation.

For any issues or questions, please feel free to open an issue on this repository.

This README provides a comprehensive guide for creating a custom Amazon EKS cluster using Terraform. It covers configuring custom AWS credentials, passing desired variable values, using a remote state backend, and customizing your cluster's networking and node group configurations. Be sure to replace placeholders with your actual content and customize it further to match your specific EKS configuration and requirements.

If you have any questions or need further assistance, don't hesitate to reach out by opening an issue on this repository. Happy Terraforming!