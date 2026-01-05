variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "s3_buckets" {
  description = "S3 bucket configuration"
  type = map(object({
    bucket_name       = string
    environment       = string
    enable_versioning = bool
    block_public      = bool
  }))
}
