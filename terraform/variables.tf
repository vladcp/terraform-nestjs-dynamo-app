variable "aws_region" {
  description = "AWS Resource Region"
  type        = string
  default = "eu-west-2"
}

variable "nestjs_container_port" {
  description = "Port of the nestjs Docker container"
  type = number
  default = 3000
}

variable "deploy" {
  description = "Temporary value to enable/disable deploy features"
  type = bool
  default = false
}

variable "book_table_name" {
  type = string
  default = "book" 
}

variable "environment" {
  description = "Environment Name"
  type = string
}
