# Latest Amazon Linux 2023 AMI via the public SSM parameter
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_ids, count.index)
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.instance_profile
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip
  user_data                   = var.user_data == "" ? null : var.user_data

  metadata_options {
    http_tokens   = "required" # enforce IMDSv2
    http_endpoint = "enabled"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = { Name = "${var.name}-${count.index + 1}" }
}
