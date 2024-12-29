data "aws_vpc" "default" {
  default = true
}

#Default VPC
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_lb" "this" {
  for_each = var.load_balancers

  name               = each.value.name
  internal           = each.value.internal
  load_balancer_type = each.value.type
  security_groups    = [for sg in each.value.security_groups : var.security_groups[sg]]
  subnets            = data.aws_subnets.default_vpc_subnets.ids

  enable_deletion_protection = each.value.enable_deletion_protection
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name     = each.value.name
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = each.value.health_check.path
  }
}

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this[each.value.load_balancer_name].arn
  port              = each.value.port
  protocol          = each.value.protocol

  dynamic "default_action" {
    for_each = each.value.default_actions
    content {
      type             = default_action.value.type
      target_group_arn = aws_lb_target_group.this[default_action.value.target_group_name].arn
    }
  }
  depends_on = [ aws_lb.this,aws_lb_target_group.this ]
}