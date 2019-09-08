# Provider and tf state config

provider "aws" {
  shared_credentials_file = "~/.aws/config"
  profile = "latam-sandbox"
  region = "us-east-1"
}

terraform {
  backend "s3" {
  region = "us-east-1"
  bucket = "terraform-state-bucket-s"
  key = "webserver-state-1/stack.tfstate"
  dynamodb_table = "terraform-state-locks"
  }
}
