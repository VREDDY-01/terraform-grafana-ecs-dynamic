output "load_balancer_arns_with_url" {
  value = {
    for name, lb in module.load_balancers.load_balancer_dns : 
    name => "http://${lb}"
  }
}