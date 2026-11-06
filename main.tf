data "aws_caller_identity" "current" {}

locals {
  name = "${var.project}-${var.environment}"
}

module "vpc" {
  source = "./modules/vpc"

  name                     = local.name
  aws_region               = var.aws_region
  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_subnet_cidrs     = var.private_subnet_cidrs
  enable_nat_gateway       = var.enable_nat_gateway
  enable_ssm_vpc_endpoints = var.enable_ssm_vpc_endpoints
}

module "security_groups" {
  source = "./modules/security_groups"

  name              = local.name
  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = var.vpc_cidr
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}

module "s3" {
  source = "./modules/s3"

  # Account ID in the name keeps it globally unique
  bucket_name = "${local.name}-${data.aws_caller_identity.current.account_id}-assets"
}

module "iam" {
  source = "./modules/iam"

  name       = local.name
  bucket_arn = module.s3.bucket_arn
}

module "web" {
  source = "./modules/ec2"

  name                = "${local.name}-web"
  instance_count      = var.web_instance_count
  instance_type       = var.instance_type
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [module.security_groups.web_sg_id]
  instance_profile    = module.iam.instance_profile_name
  key_name            = var.key_name
  associate_public_ip = true
  user_data           = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
    echo "<h1>${local.name} web $(hostname)</h1>" > /usr/share/nginx/html/index.html
  EOT
}

module "app" {
  source = "./modules/ec2"

  name                = "${local.name}-app"
  instance_count      = var.app_instance_count
  instance_type       = var.instance_type
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.security_groups.app_sg_id]
  instance_profile    = module.iam.instance_profile_name
  key_name            = var.key_name
  associate_public_ip = false
  user_data           = ""
}
