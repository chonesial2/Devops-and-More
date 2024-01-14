// Create ECS cluster
resource "aws_ecs_cluster" "awscluster" {
  name = var.family

}

// Create task definition
resource "aws_ecs_task_definition" "taskdef" {
  family                = var.family
  container_definitions = jsonencode([
    {
      name          = var.contname
      image         = var.imagename
      cpu           = 1
      memory        = 3
      essential     = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

// Create ECS service
resource "aws_ecs_service" "service" {

  name            = "service"
  cluster         = aws_ecs_cluster.awscluster.id
  task_definition = aws_ecs_task_definition.taskdef.arn
  desired_count   = 1
  
}
