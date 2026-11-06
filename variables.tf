variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name, used for naming and tagging"
  type        = string
  default     = "tf-infra"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "Create a single NAT gateway for private subnets (costs money)"
  type        = bool
  default     = false
}

variable "enable_ssm_vpc_endpoints" {
  description = "Create SSM interface endpoints so private instances can use Session Manager without NAT (incurs endpoint charges)"
  type        = bool
  default     = false
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH to the web tier. Use your own /32, never 0.0.0.0/0."
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Optional EC2 key pair name. Leave null to use SSM Session Manager only."
  type        = string
  default     = null
}

variable "web_instance_count" {
  description = "Number of web instances in public subnets"
  type        = number
  default     = 2
}

variable "app_instance_count" {
  description = "Number of app instances in private subnets"
  type        = number
  default     = 1
}
