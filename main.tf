module "security_groups" {
  source = "./modules/security_groups"
  security_groups = var.security_groups
  }