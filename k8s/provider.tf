terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.60.0, < 6.0.0"
    }
  }

  backend "s3" {
    bucket         = "deploy-aws-terra"         # Nama bucket S3
    key            = "terraform/state/aws/terraform.tfstate" # Lokasi file state
    region         = "us-east-1"               # Wilayah AWS
    dynamodb_table = "terraform-lock-table"    # DynamoDB untuk state locking
    encrypt        = true                      # Enkripsi state file
  }
}

provider "aws" {
  region = "us-east-1" # Wilayah AWS (ganti jika perlu)

  default_tags {
    tags = {
      Environment = "Production"
      Project     = "K8S Cluster"
    }
  }
}
