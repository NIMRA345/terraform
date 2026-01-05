s3_buckets = {
  dev = {
    bucket_name = "nimra-dev-bucket-2026"
    environment = "Dev"
    versioning  = true
    acl         = "private"
    block_public = {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }
  }

  prod = {
    bucket_name = "nimra-prod-bucket-2026"
    environment = "Prod"
    versioning  = true
    acl         = "private"
    block_public = {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }
  }
}
