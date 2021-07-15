output "instance_profile_arn" {
  description = "Instance profile role arn"
  value       = aws_iam_instance_profile.instance_profile.arn
}

