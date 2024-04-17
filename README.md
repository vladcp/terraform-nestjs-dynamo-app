## Terraform AWS infrastructure for ECS deployment of NestJS + DynamoDB App

### Bootstrap the state file 
When first setting up an account under config/terraform/ run the terraform-bootstrap module to configure backend bucket and dynamodb table for terraform.


cd layers/base
terraform init --reconfigure --backend-config="../../config/sandbox8/base/base.s3.tfbackend"
terraform apply --var-file="../../config/sandbox8/base/default.tfvars"


cd layers/app
terraform init --reconfigure --backend-config="../../config/sandbox8/app/app.s3.tfbackend"
terraform apply --var-file="../../config/sandbox8/app/default.tfvars" --auto-approve


cd layers/deploy
terraform init --reconfigure --backend-config="../../config/sandbox8/deploy/deploy.s3.tfbackend"
terraform apply --var-file="../../config/sandbox8/deploy/default.tfvars"

