provider "aws" {
  region = "us-east-1"
}

locals {
  bucket_name = "nimra-single-file-s3-123"
  common_tags = {
    Name        = "Single File S3"
    Environment = "Dev"
  }
}

# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = local.bucket_name
  tags   = local.common_tags
}

# Upload file using new resource
resource "aws_s3_object" "bucket_file" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "bucketimg.png"
  source = "C:/Users/ZBOOK/Desktop/BUCKET/S3 bucket/bucketimg.png"
  acl    = "private"
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
