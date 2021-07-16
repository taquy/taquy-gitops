output "secret" {
  value = module.secrets.secret
}

output "secret_version" {
  value = module.secrets.secret_version
}

output "jenkins_node_user_key" {
  value = module.iam.jenkins_node_user_key
}