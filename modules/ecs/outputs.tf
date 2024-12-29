output "ecs_clusters" {
  description = "The ECS clusters created"
  value       = aws_ecs_cluster.ecs_cluster
}

output "ecs_services" {
  description = "The ECS services created"
  value       = aws_ecs_service.ecs_service
}
