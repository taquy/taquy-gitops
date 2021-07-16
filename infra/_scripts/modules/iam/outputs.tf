output "instance_profile_arn" {
  description = "Instance profile role arn"
  value       = aws_iam_instance_profile.instance_profile.arn
}

output "jenkins_node_user_key" {
  description = "Jenkins node user access key"
  # sensitive   = true
  value = {
    id = aws_iam_access_key.jenkins_node_user_key.id
    secret = aws_iam_access_key.jenkins_node_user_key.secret
  }
}