terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional: remote state (create the bucket + DynamoDB table first)
  # backend "s3" {
  #   bucket         = "my-tf-state-bucket"
  #   key            = "aws-infra/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}
