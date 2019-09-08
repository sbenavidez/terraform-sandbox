# first create the remote state resoruces to be used then on the stack

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}

# Create the s3 bucket for remote state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket-s"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "terraform-state-bucket"
    Createdby   = "Santiago"
  }
}

# Create DynamoDB table for user locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-state-locks"
    Createdby   = "Santiago"
  }

}