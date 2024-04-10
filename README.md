## Terraform AWS infrastructure for ECS deployment of NestJS + DynamoDB App

### Bootstrap the state file 
When first setting up an account under config/terraform/ run the terraform-bootstrap module to configure backend bucket and dynamodb table for terraform.

Setup dynamodb table for nestjs app
Setup environment variables for the nestjs app
Run apply through github actions on every pull/ PR?

terraform init --reconfigure --backend-config="../config/terraform/sandbox8/backend.conf"

terraform apply --var-file="../config/terraform/sandbox8/default.tfvars"

