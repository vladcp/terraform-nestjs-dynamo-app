variable "aws_region" {
  description = "AWS Resource Region"
  type        = string
  default = "eu-west-2"
}

variable "app_docker_image" {
  description = "Docker Image for the NestJS app"
  type        = string
  default     = "docker.io/vladcp/nestjs-app:latest"
}

variable "nestjs_container_port" {
  description = "Port of the nestjs Docker container"
  type = number
  default = 3000
}

variable "deploy" {
  description = "Temporary value to enable/disable deploy features"
  type = bool
  default = true
}

variable "book_table_name" {
  type = string
  default = "book" 
}

variable "environment" {
  description = "Deployed environment identifier"
  type        = string
  default     = "dev"
}
