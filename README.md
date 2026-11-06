# AWS Infrastructure Provisioning with Terraform

Infrastructure as Code project that provisions a two-tier AWS environment from reusable modules.

## Architecture

| Module | Resources |
|---|---|
| `vpc` | VPC, public/private subnets across AZs, IGW, route tables, private S3 gateway endpoint, optional NAT and SSM interface endpoints |
| `security_groups` | Web SG (80/443 public, SSH from allowed CIDRs), App SG (8080 from web SG only) |
| `iam` | EC2 role, SSM Session Manager access, least-privilege S3 policy, instance profile |
| `s3` | Private bucket with versioning, SSE, public access block, lifecycle rule |
| `ec2` | Amazon Linux 2023 instances, IMDSv2 enforced, encrypted gp3 root volume |

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # set allowed_ssh_cidrs to your IP/32
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out tfplan
terraform apply tfplan
terraform destroy      # when finished, to avoid charges
```

## Notes

- Private-subnet instances have no internet access unless `enable_nat_gateway = true`
  (about $32/month plus data). To use Session Manager on private instances without NAT,
  set `enable_ssm_vpc_endpoints = true`; this creates SSM and SSM Messages interface
  endpoints, which incur per-endpoint, per-AZ, and data-processing charges.
- A free S3 gateway endpoint is attached to the private route table so private instances
  can reach S3 without NAT; their IAM policy still limits access to the project bucket.
- Instances are managed via SSM Session Manager; `key_name` and SSH CIDRs are optional.
- Enable the commented S3 backend in `versions.tf` for remote state with locking.

## Possible extensions

CI pipeline (GitHub Actions running fmt, validate, tflint, tfsec/checkov, plan on PR),
separate `envs/dev` and `envs/prod` directories, ALB + Auto Scaling group module, and
VPC endpoints for additional AWS services.
