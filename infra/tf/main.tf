
module "network" {
  source         = "./modules/network"
  namespace      = var.network.namespace
  vpc_cidr_block = var.network.vpc_cidr_block
  tags           = var.network.tags
  source_ip = [
    "${var.my_ip}/32"
  ]
}

module "iam" {
  source = "./modules/iam"
  depends_on = [
    module.network
  ]
  namespace = var.iam.namespace
  source_ip = [
    module.network.vm_public_ip,
    "${var.my_ip}/32"
  ]
  pgp_key = var.pgp_key
  tags    = var.network.tags
}

module "kms" {
  source     = "./modules/kms"
  tags       = var.kms.tags
  namespace  = var.kms.namespace
  key_admins = concat(var.kms.key_admins, [])
  key_users = concat(var.kms.key_users, [
    module.iam.instance_role_arn,
    module.iam.jenkins_job_role_arn
  ])
}

module "secrets" {
  source    = "./modules/secrets"
  namespace = var.secrets.namespace
  secrets   = var.secrets.secrets
  kms_key_id = module.kms.key_id
  source_ip = [
    module.network.vm_public_ip,
    "${var.my_ip}/32"
  ]
  trusted_identities = [
    module.iam.instance_role_arn,
    module.iam.jenkins_job_role_arn
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