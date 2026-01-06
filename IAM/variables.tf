variable "iam_roles" {
  type = map(object({
    service             = string
    managed_policy_arns = list(string)
  }))
}
