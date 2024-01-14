//variables for ecs module resources

//for provider and vpc

variable "aws_region" {
  default     = "ap-south-1"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}

//variable for counting function of variable resources
variable "az_count" {
  default     = "2"
  description = "number of availability zones in above region"
}

//variable for provider

variable "organization" {
  default = "autoprods"
  type = string 
  description = "Name of the organization"
}

//Health check path 
variable "health_check_path" {
  default = "/"
}


//alb outbound port listening 
variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

//for task definition

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}

//aws task execution role name 
variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "app_image" {
  default     = "nginx:latest"
  description = "docker image to run in this ECS cluster"
}