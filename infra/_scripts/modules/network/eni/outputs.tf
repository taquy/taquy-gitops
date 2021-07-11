output "vm_eip" {
  description = "VM's elastic ip"
  value       = aws_eip.vm_eip
}

output "vm_eni" {
  description = "VM's elastic network interface id"
  value       = aws_network_interface.vm_eni.id
}
