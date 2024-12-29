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

module "ecs_service" {
  source = "./modules/ecs"
  ecs_clusters = var.ecs_clusters
  task_definitions = var.task_definitions
  security_groups = module.security_groups.security_group_ids
  ecs_services = var.ecs_services
  target_group_arns = module.load_balancers.target_group_arns
}