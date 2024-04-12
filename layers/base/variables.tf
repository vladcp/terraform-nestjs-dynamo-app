variable "aws_region" {
  description = "AWS Resource Region"
  type        = string
  default = "eu-west-2"
}
variable "environment" {
  description = "Deployed environment identifier"
  type        = string
  default     = "dev"
}