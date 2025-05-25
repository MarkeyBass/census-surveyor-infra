provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
  environment = var.environment
}

# This will be used later for VPC and EC2
# module "vpc" {
#   source = "../../modules/vpc"
#   ...
# }

# module "ec2" {
#   source = "../../modules/ec2"
#   ...
# }

data "aws_caller_identity" "current" {} 