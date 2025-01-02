terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }

  backend "s3" {
    bucket         = "deploy-aws-terra"         # Nama bucket S3 Anda
    key            = "terraform/state/aws/terraform.tfstate" # Lokasi file state di bucket
    region         = "us-east-1"               # Wilayah AWS
    dynamodb_table = "terraform-lock-table"    # Tabel DynamoDB untuk lock
    encrypt        = true                      # Enkripsi file state
  }
}

provider "aws" {
  default_tags {
    # Tambahkan tags default jika perlu
  }
}
