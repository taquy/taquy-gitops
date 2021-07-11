
module "secrets" {
  source    = "./modules/secrets"
  namespace = var.secrets.namespace
  secrets   = var.secrets.secrets
}

module "network" {
  source    = "./modules/network"
  namespace      = var.network.namespace
  vpc_cidr_block      = var.network.vpc_cidr_block
  tags      = var.network.tags
}