output "instance_profile" {
  description = "Instance profile"
  value = {
    arn  = aws_iam_instance_profile.instance_profile.arn
    name = aws_iam_instance_profile.instance_profile.name
  }
}

output "instance_role_arn" {
  description = "Instance role arn"
  value       = aws_iam_role.instance_role.arn
}

output "jenkins_node_role_arn" {
  description = "Jenkins node role arn"
  value       = aws_iam_user.jenkins_node_user.arn
}

output "jenkins_node_user_key" {
  description = "Jenkins node user access key"
  sensitive   = true
  value = {
    id     = aws_iam_access_key.jenkins_node_user_key.id,
    secret = aws_iam_access_key.jenkins_node_user_key.encrypted_secret
  }
}