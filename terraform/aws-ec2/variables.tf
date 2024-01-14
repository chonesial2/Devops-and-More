variable "region" {
  type        = string
  description = "availability zone mumbai"
  default     = "ap-south-1"
}


variable "access" {
  type        = string
  description = "access key for iam"
  default     = "xxxxxxxxxx" 
}

variable "secret" {
  type        = string
  description = "secret key for IAM"
  default     = "xxxxxxxxxxxxxxxxxx"
}

variable "ami" {
  type        = string
  description = "image""
  default     = "ami-0a5dcff6fb7af3fc9"
} 

variable "instance" {
  type        = string
  description = "compatible instance will ami"
  default     = "t2-micro"
}
