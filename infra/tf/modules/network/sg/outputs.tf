output "vm_sg_id" {
  description = "Network interface's security group"
  value       = aws_security_group.vm_sg.id
}
