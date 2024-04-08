variable "aws_region" {
  description = "AWS Resource Region"
  type        = string
  default = "eu-west-2"
}

variable "nestjs_container_port" {
  type = number
  default = 3000
  description = "Port of the nestjs Docker container"
}

variable "deploy" {
  type = bool
  default = false
  description = "Temporary value to enable/disable deploy features"
}