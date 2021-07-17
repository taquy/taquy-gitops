
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
  namespace = var.network.namespace
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

module "compute" {
  source = "./modules/compute"
  depends_on = [
    module.iam
  ]
  name                 = var.compute.name
  namespace            = var.compute.namespace
  key_path             = var.compute.key_path
  instance             = var.compute.instance
  instance_profile_arn = module.iam.instance_profile_arn
  tags                 = var.compute.tags
  vm_eni               = module.network.vm_eni
}