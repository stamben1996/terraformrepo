provider "aws" {
        region = "us-east-1"
        profile = "terraform"
}

terraform {
  backend "s3" {
    bucket         = "bucket-terraform-stamben"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "table-terraform-stamben"
  }
}


module "vpc" {
  source = "../../modules/vpc"
}

module "elb" {
  source       = "../../modules/elb"
  elb_port     = var.elb_port
  server_port  = var.server_port
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.subnet_ids
  target_group_arn = module.elb.target_group_arn
}

module "asg" {
  source           = "../../modules/asg"
  server_port      = var.server_port
  ami_id           = var.ami_id
  ec2_type         = var.ec2_type
  subnet_ids       = module.vpc.subnet_ids
  target_group_arn = module.elb.target_group_arn
}

output "alb_dns_name" {
  value = module.elb.alb_dns_name
}

#testcambio1