output "vm_public_ip" {
  description = "Elastic public IP of VM"
  value       = module.eni.vm_eip.public_ip
}