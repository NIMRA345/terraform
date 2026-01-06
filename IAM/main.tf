resource "aws_iam_role" "aws-iam" {
  for_each = var.iam_roles

  name = each.key

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = each.value.service
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach managed policies
resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.iam_roles

  role       = aws_iam_role.this[each.key].name
  policy_arn = each.value.managed_policy_arns[0]
}
