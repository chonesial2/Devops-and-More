variable "family" {
  type        = string
  description = "aws_ecs_task_definition "
  
}

variable "contname" {
  type        = string
  description = "name of container taskfamily"
}

variable "imagename" {
  type        = string
  description = "image to be used for container "
}



variable "organization" {
  type        = string
}
