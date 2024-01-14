
//Task definition using the variables 

resource "aws_ecs_task_definition" "test-def" {
  family                   = "testapp-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
 

 //Container definition for ECS . 

   container_definitions = jsonencode([
    {
      "name": "testapp",
      "image": var.app_image,
      "cpu": tonumber(var.fargate_cpu),
      "memory": tonumber(var.fargate_memory),
      "networkMode": "awsvpc",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/testapp",
          "awslogs-region": var.aws_region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": tonumber(var.app_port),
          "hostPort": tonumber(var.app_port)
        }
      ]
    }
  ])
}

//starting the service 
resource "aws_ecs_service" "test-service" {
  name            = "testapp-service"
  cluster         = aws_ecs_cluster.test-cluster.id
  task_definition = aws_ecs_task_definition.test-def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

//Configuration for the service 
network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

//associating load balancer inside . 

  load_balancer {
    target_group_arn = aws_alb_target_group.myapp-tg.arn
    container_name   = "testapp"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.testapp, aws_iam_role_policy_attachment.ecs_task_execution_role]
}


