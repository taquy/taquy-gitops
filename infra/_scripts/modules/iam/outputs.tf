output "vm_profile_arn" {
  description = "Instance profile role arn"
  value       = aws_iam_instance_profile.vm_profile.arn
}

