provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
  environment = var.environment
}

module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  vpc_cidr    = "10.0.0.0/16"
}

module "ec2" {
  source = "../../modules/ec2"

  environment        = var.environment
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.vpc.ec2_security_group_id
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id
}

data "aws_caller_identity" "current" {} 