provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "ec2" {
  source = "../../modules/ec2"

  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.vpc.public_subnet_ids[0]
  vpc_security_group_id = module.vpc.ec2_security_group_id
  security_group_id     = module.vpc.ec2_security_group_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id
  instance_type         = var.instance_type
  ssh_key_name          = var.ssh_key_name

  tags = var.tags
}

module "route53" {
  source = "../../modules/route53"

  environment = var.environment
  domain_name = var.domain_name
  elastic_ip  = module.ec2.elastic_ip
  tags        = var.tags
}

data "aws_caller_identity" "current" {} 
