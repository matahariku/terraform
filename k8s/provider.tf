terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.60.0, < 6.0.0"
    }
  }

  backend "s3" {
    bucket         = "terra-farida"         # Name bucket S3
    key            = "terraform/state/aws/terraform.tfstate" # Location file state
    region         = "us-east-1"               
    dynamodb_table = "terraform-lock-table"    # DynamoDB for state locking
    encrypt        = true                      
  }
}

provider "aws" {
  region = "us-east-1" 

  default_tags {
    tags = {
      Environment = "Production"
      Project     = "K8S Cluster"
    }
  }
}
