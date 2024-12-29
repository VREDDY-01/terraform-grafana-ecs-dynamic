data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  for_each = toset(var.ecs_clusters)
  name = each.value
}

resource "aws_ecs_task_definition" "task_definition" {
  for_each = { for td in var.task_definitions : td.family => td }

  family                   = each.value.family
  requires_compatibilities = [each.value.launch_type]
  cpu = each.value.task_cpu
  memory = each.value.task_memory
  network_mode = "awsvpc"
  container_definitions    = jsonencode(each.value.container_defs)
}

resource "aws_ecs_service" "ecs_service" {
  for_each = { for service in var.ecs_services : service.service_name => service }

  name            = each.value.service_name
  cluster         = aws_ecs_cluster.ecs_cluster[each.value.cluster_name].id
  task_definition = aws_ecs_task_definition.task_definition[each.value.task_definition].arn
  desired_count   = each.value.desired_count
  launch_type = "FARGATE"

  dynamic "load_balancer" {
    for_each = each.value.load_balancers

    content {
      target_group_arn = var.target_group_arns[load_balancer.value.target_group_name]
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  network_configuration {
    subnets          = data.aws_subnets.default_vpc_subnets.ids
    security_groups = [var.security_groups[each.value.sg_name]]  
  }

  depends_on = [ aws_ecs_task_definition.task_definition ]
}