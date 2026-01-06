iam_roles = {
  ec2_s3_role = {
    service             = "ec2.amazonaws.com"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
  }
}
