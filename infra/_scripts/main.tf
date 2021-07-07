
module "secrets" {
  source    = "./modules/aws-secret-manager"
  namespace = var.namespace
  secrets   = var.secrets
}