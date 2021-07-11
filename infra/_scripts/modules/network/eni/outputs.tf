output "vm_eip" {
  description = "VM's elastic public ip"
  value       = aws_eip.vm_eip.public_ip
}
