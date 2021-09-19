output "vm_eip" {
  description = "VM's elastic ip"
  value       = aws_eip.vm_eip[0]
}

output "vm_eni" {
  description = "VM's elastic network interface id"
  value       = aws_network_interface.vm_eni[0].id
}
