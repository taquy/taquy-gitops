
module "network" {
  source         = "./modules/network"
  namespace      = var.network.namespace
  vpc_cidr_block = var.network.vpc_cidr_block
  tags           = var.network.tags
}
module "iam" {
  source = "./modules/iam"
  depends_on = [
    module.network
  ]
  namespace = var.iam.namespace
  source_ip = [
    module.network.vm_public_ip,
    var.my_ip
  ]
  pgp_key = var.pgp_key
  tags    = var.network.tags
}

module "secrets" {
  source    = "./modules/secrets"
  namespace = var.secrets.namespace
  secrets   = var.secrets.secrets
  source_ip = [
    module.network.vm_public_ip,
    var.my_ip
  ]
  trusted_identities = [
    module.iam.instance_role_arn,
    module.iam.jenkins_node_role_arn,
  ]
}

module "dns" {
  source = "./modules/dns"
  depends_on = [
    module.network
  ]
  namespace    = var.dns.namespace
  vm_public_ip = module.network.vm_public_ip
  domain_name  = var.dns.domain_name
  records      = var.dns.records
  tags         = var.dns.tags
}

module "compute" {
  source = "./modules/compute"
  depends_on = [
    module.iam
  ]
  name             = var.compute.name
  namespace        = var.compute.namespace
  key_path         = var.compute.key_path
  instance         = var.compute.instance
  instance_profile = module.iam.instance_profile
  tags             = var.compute.tags
  vm_eni           = module.network.vm_eni
}