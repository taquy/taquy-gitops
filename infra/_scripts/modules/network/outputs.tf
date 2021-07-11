output "vm_public_ip" {
  description = "Elastic public IP of VM"
  value       = aws_eip.vm_eip.public_ip
}
