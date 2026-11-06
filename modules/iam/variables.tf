variable "name" {
  type = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket instances may read/write"
  type        = string
}
