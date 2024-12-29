region = "ap-south-1"
security_groups = {
  Application-sg = {
    name        = "Application-sg"
    description = "Allow 80,9090,9100"
    ingress_rules = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 9090
        to_port     = 9090
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 9100
        to_port     = 9100
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
  Monitoring-sg = {
    name        = "Monitoring-sg"
    description = "Allow 80 and 3000"
    ingress_rules = [
      {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

load_balancers = {
  application-lb = {
    name                      = "application-lb"
    internal                  = false
    type                      = "application"
    security_groups           = ["Application-sg"]
    enable_deletion_protection = false
  },
  monitoring-lb = {
    name                      = "monitoring-lb"
    internal                  = false
    type                      = "application"
    security_groups           = ["Monitoring-sg"]
    enable_deletion_protection = false
  }
}

target_groups = {
  prometheus-tg = {
    name     = "prometheus-tg"
    port     = 9090
    protocol = "HTTP"

    health_check = {
      path                = "/query"
    }
  },
  sfr-tg = {
    name     = "sfr-tg"
    port     = 80
    protocol = "HTTP"

    health_check = {
      path                = "/"
    }
  },
  grafana-tg = {
    name     = "grafana-tg"
    port     = 3000
    protocol = "HTTP"

    health_check = {
      path                = "/login"
    }
  },
}

listeners = {
  prometheus-listener = {
    load_balancer_name = "application-lb"
    port               = 9090
    protocol           = "HTTP"

    default_actions = [
      {
        type              = "forward"
        target_group_name = "prometheus-tg"
      }
    ]
  },
  sfr-listener = {
    load_balancer_name = "application-lb"
    port               = 80
    protocol           = "HTTP"

    default_actions = [
      {
        type              = "forward"
        target_group_name = "sfr-tg"
      }
    ]
  },
  grafana-listener = {
    load_balancer_name = "monitoring-lb"
    port               = 80
    protocol           = "HTTP"

    default_actions = [
      {
        type              = "forward"
        target_group_name = "grafana-tg"
      }
    ]
  },
}

ecs_clusters = ["SFR-Cluster"]
  
task_definitions = [
    {
      family        = "Application-task"
      launch_type = "FARGATE"
      task_cpu = "2048"
      task_memory = "4096"
      container_defs = [
        {
          name      = "prometheus"
          image     = "vreddy1910/prometheus:latest"
          cpu       = 512
          memory    = 1024
          essential = true
          portMappings = [
            {
              containerPort = 9090  
              hostPort      = 9090  
              protocol      = "tcp"
            }
          ]
        },
        {
          name      = "sfr"
          image     = "vreddy1910/sfr_web:latest"
          cpu       = 512
          memory    = 1024
          essential = true
          portMappings = [
            {
              containerPort = 80  
              hostPort      = 80  
              protocol      = "tcp"
            }
          ]
        },
        {
          name      = "node"
          image     = "prom/node-exporter:latest"
          cpu       = 512
          memory    = 1024
          essential = true
          portMappings = [
            {
              containerPort = 9100  
              hostPort      = 9100  
              protocol      = "tcp"
            }
          ]
        }
      ]
    },
    {
      family        = "Monitoring-task"
      launch_type = "FARGATE"
      task_cpu = "2048"
      task_memory = "4096"
      container_defs = [
        {
          name      = "grafana"
          image     = "grafana/grafana:latest"
          cpu       = 1024
          memory    = 2048
          essential = true
          portMappings = [
            {
              containerPort = 3000  
              hostPort      = 3000  
              protocol      = "tcp"
            }
          ]
        }
      ]
    }
]

ecs_services = [
    {
      cluster_name      = "SFR-Cluster"
      service_name      = "Application-service"
      desired_count     = 2
      task_definition   = "Application-task"
      sg_name = "Application-sg"
      load_balancers = [
      {
        target_group_name = "prometheus-tg"
        container_name = "prometheus"
        container_port = 9090
      },
      {
        target_group_name = "sfr-tg"
        container_name = "sfr"
        container_port = 80
      },
      ]
    },
      {
      cluster_name      = "SFR-Cluster"
      service_name      = "Monitoring-service"
      desired_count     = 2
      task_definition   = "Monitoring-task"
      sg_name = "Monitoring-sg"
      load_balancers = [
      {
        target_group_name = "grafana-tg"
        container_name = "grafana"
        container_port = 3000
      }
      ]
    }
]
