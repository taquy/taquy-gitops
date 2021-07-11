
module "secrets" {
  source    = "./modules/aws-secret-manager"
  namespace = var.secrets.namespace
  secrets   = var.secrets.secrets
}

module "ec2" {
  source    = "./modules/aws-ec2-instance"
  name = var.ec2.name
  namespace = var.ec2.namespace
  region = var.ec2.region
  key_path = var.ec2.key_path
  tags = var.ec2.tags
  instance = var.ec2.instance
}