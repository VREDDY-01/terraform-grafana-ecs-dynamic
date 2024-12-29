variable "region" {
  type = string
}

variable "security_groups" {
  description = "A map of security group definitions. Each key should map to a security group."
  type = map(object({
    name          = string
    description   = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "load_balancers" {
  description = "A map of load balancers to create."
  type = map(object({
    name                      = string
    internal                  = bool
    type                      = string
    security_groups           = list(string)
    enable_deletion_protection = bool
  }))
}

variable "target_groups" {
  description = "A map of target groups to create."
  type = map(object({
    name     = string
    port     = number
    protocol = string

    health_check = object({
      path                = string
    })
  }))
}

variable "listeners" {
  description = "A map of listeners to create."
  type = map(object({
    load_balancer_name = string
    port               = number
    protocol           = string

    default_actions = list(object({
      type              = string
      target_group_name = string
    }))
  }))
}

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
