terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "tfuser"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
  azs        = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "alb" {
  source = "./modules/alb"

  alb_name          = "demo-alb"
  vpc_id            = module.vpc.id
  public_subnet_ids = module.vpc.public_subnet_ids

  depends_on = [module.vpc]
}

module "ecs" {
  source = "./modules/ecs"

  cluster_name         = "demo"
  vpc_id               = module.vpc.id
  private_subnet_ids   = module.vpc.private_subnet_ids
  alb_target_group_arn = module.alb.target_group
  alb_security_group   = module.alb.security_group
  alb_dns              = module.alb.dns

  depends_on = [module.vpc, module.alb]
}

output "DNS" {
  value       = "http://${module.alb.dns}"
  description = "DNS name of the load balancer"
  depends_on  = [module.ecs]
}
