output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "web_public_ips" {
  value = module.web.public_ips
}

output "app_private_ips" {
  value = module.app.private_ips
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "iam_role_arn" {
  value = module.iam.role_arn
}
