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