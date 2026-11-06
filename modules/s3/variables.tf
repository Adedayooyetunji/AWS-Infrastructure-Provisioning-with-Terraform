variable "bucket_name" {
  type = string
}

variable "force_destroy" {
  description = "Allow destroying a non-empty bucket (use true only for dev)"
  type        = bool
  default     = false
}
