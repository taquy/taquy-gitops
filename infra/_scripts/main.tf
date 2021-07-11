
module "secrets" {
  source    = "./modules/secrets"
  namespace = var.secrets.namespace
  secrets   = var.secrets.secrets
}

module "network" {
  source         = "./modules/network"
  namespace      = var.network.namespace
  vpc_cidr_block = var.network.vpc_cidr_block
  tags           = var.network.tags
}
module "iam" {
  source         = "./modules/iam"
  depends_on = [
    module.network
  ]
  namespace      = var.network.namespace
  source_ip      = concat(var.my_ip, var.network.source_ip, [
    module.network.vm_public_ip
  ])
  tags           = var.network.tags
}

module "compute" {
  source = "./modules/compute"
  depends_on = [
    module.iam
  ]
  name      = var.compute.name
  namespace = var.compute.namespace
  key_path  = var.compute.key_path
  instance  = var.compute.instance
  vm_profile_arn = module.iam.vm_profile_arn
  tags      = var.compute.tags
}

