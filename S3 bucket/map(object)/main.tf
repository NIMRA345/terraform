provider "aws" {
  region = var.aws_region
}

############################
# S3 BUCKETS
############################
resource "aws_s3_bucket" "my_bucket" {
  for_each = var.s3_buckets

  bucket = each.value.bucket_name

  tags = {
    Name        = each.key
    Environment = each.value.environment
  }
}

############################
# S3 VERSIONING (CONDITIONAL)
############################
resource "aws_s3_bucket_versioning" "versioning" {
  for_each = {
    for k, v in var.s3_buckets : k => v
    if v.enable_versioning
  }

  bucket = aws_s3_bucket.my_bucket[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}

############################
# BLOCK PUBLIC ACCESS
############################
resource "aws_s3_bucket_public_access_block" "block_public" {
  for_each = {
    for k, v in var.s3_buckets : k => v
    if v.block_public
  }

  bucket = aws_s3_bucket.my_bucket[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
