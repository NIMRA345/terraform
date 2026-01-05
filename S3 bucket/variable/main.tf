# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Single File S3"
    Environment = var.environment
  }
}

# Enable Versioning (conditional)
resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.enable_versioning ? 1 : 0  # <--- condition
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
