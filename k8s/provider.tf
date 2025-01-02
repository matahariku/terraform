terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

 backend "s3" {
    bucket         = "deploy-aws-terra"         
    key            = "terraform/state/aws/terraform.tfstate" 
    region         = "us-east-1"               
    dynamodb_table = "terraform-lock-table"    
    encrypt        = true                     
  }
}

provider "aws" {
  default_tags {
  }
}
