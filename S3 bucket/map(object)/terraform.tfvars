aws_region = "us-east-1"
  
  s3_buckets = {
  logs = {
    bucket_name       = "nimra-logs-bucket-2026"
    environment       = "prod"
    enable_versioning = true
    block_public      = true
  }

  uploads = {
    bucket_name       = "nimra-uploads-bucket-2026"
    environment       = "dev"
    enable_versioning = false
    block_public      = true
  }
}
