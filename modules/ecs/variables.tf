variable "ecs_clusters" {
  description = "List of ECS cluster names"
  type        = list(string)
}

variable "task_definitions" {
  description = "List of ECS task definitions with multiple containers"
  type        = list(object({
    family           = string
    launch_type = string
    task_cpu = string
    task_memory = string
    container_defs   = list(object({
      name      = string
      image     = string
      cpu       = number
      memory    = number
      essential = bool
      portMappings = list(object({
          containerPort = number
          hostPort      = number
          protocol      = string
      }))
    }))
  }))
}

variable "ecs_services" {
  description = "List of ECS services"
  type        = list(object({
    cluster_name      = string
    service_name      = string
    desired_count     = number
    task_definition   = string
    sg_name = string
    load_balancers = list(object({
      target_group_name = string
      container_name = string
      container_port = number
    }))
  }))
}

variable "target_group_arns" {
  type = map(string)
}

variable "security_groups" {
  type = map(string)
}