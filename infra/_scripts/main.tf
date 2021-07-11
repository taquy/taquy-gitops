
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

module "compute" {
  source = "./modules/compute"
  depends_on = [
    module.network
  ]
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_1a_id
  name      = var.compute.name
  namespace = var.compute.namespace
  key_path  = var.compute.key_path
  instance  = var.compute.instance
  tags      = var.compute.tags
}


module "iam" {
  source         = "./modules/iam"
  namespace      = var.network.namespace
  source_ip      = concat(var.my_ip, var.network.source_ip, [
    module.compute.
  ])
  tags           = var.network.tags
}
