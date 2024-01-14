//Main module file 


module "multipleecsmodule" {
  source = "./multipleecsmodule"

//variables for ecs module resources

aws_region = var.aws_region

az_count = var.az_count

health_check_path = var.health_check_path

app_port = var.app_port

fargate_cpu = var.fargate_cpu


fargate_memory = var.fargate_memory

ecs_task_execution_role = var.ecs_task_execution_role

app_count = var.app_count

app_image = var.app_image



}