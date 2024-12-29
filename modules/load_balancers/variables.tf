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

variable "security_groups" {
  type = map(string)
}
