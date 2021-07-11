
module "secrets" {
  source    = "./modules/aws-secret-manager"
  namespace = var.secrets.namespace
  secrets   = var.secrets.secrets
}

module "ec2" {
  source    = "./modules/aws-ec2-instances"
  key_path = var.ec2.key_path
  instance = var.ec2.instance
}