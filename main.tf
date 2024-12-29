module "security_groups" {
  source = "./modules/security_groups"
  security_groups = var.security_groups
}

module "load_balancers" {
  source = "./modules/load_balancers"
  load_balancers = var.load_balancers
  target_groups = var.target_groups
  listeners = var.listeners
  security_groups = module.security_groups.security_group_ids
}
