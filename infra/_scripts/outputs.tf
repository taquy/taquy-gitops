output "secret" {
  value = module.secrets.secret
}

output "secret_version" {
  value = module.secrets.secret_version
}

output "jenkins_node_user_key" {
  value = module.iam.jenkins_node_user_key
  sensitive = true
}

output "vm_public_ip" {
  description = "Elastic public IP of VM"
  value       = module.network.vm_public_ip
}