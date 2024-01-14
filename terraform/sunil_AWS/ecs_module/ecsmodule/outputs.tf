# outputs you can kist required endpoints, ip or instanceid's


output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.taskdef.arn
  description = "ARN of the ECS task definition"
}

output "ecs_service_name" {
  value       = aws_ecs_service.service.name
  description = "Name of the ECS service"
}

