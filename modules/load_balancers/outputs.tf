output "load_balancer_arns" {
  value = { for key, lb in aws_lb.this : key => lb.arn }
}

output "load_balancer_dns" {
  value = { for key, lb in aws_lb.this : key => lb.dns_name }
}

output "target_group_arns" {
  value = { for key, tg in aws_lb_target_group.this : key => tg.arn }
}

output "listener_arns" {
  value = { for key, listener in aws_lb_listener.this : key => listener.arn }
}