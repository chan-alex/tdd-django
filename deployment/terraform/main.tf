// Provider specific configs
provider "aws" {
  profile = "personal"
  region  = "ap-southeast-1"
}

######### terraform specific configration  ############
terraform {
  # Specify terraform version
  required_version = ">= 0.11"

  # Remote state in S3
  backend "s3" {
    bucket  = "chanalex-devops"
    key     = "terraform/tdd-python-staging"
    region  = "ap-southeast-1"
    profile = "personal"
  }
}
