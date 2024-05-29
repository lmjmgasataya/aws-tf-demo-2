# Terraform AWS Demo 

## Install Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

- via brew
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Create .gitignore for terraform
https://github.com/github/gitignore/blob/main/Terraform.gitignore


### VS Code useful extensions
- Terraform
- Terraform Format on Save

### Common Commands
- `terraform init` - initializes your backend
- `terraform plan` - creates an execution plan
- `terraform apply` - executes planned actions
- `terraform destroy` - destroy resources

### Run terraform plan without aws credentials
https://stackoverflow.com/questions/54269578/terraform-run-plan-without-aws-credentials

```
provider "aws" {
  region                      = "ap-southeast-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}
```
#### Error you'll encounter with having mock aws credentials

```
│Error: reading EC2 AMIs: AuthFailure: AWS was not able to validate the provided access credentials
│       status code: 401, request id: 5b3ad33d-429b-427a-8488-b763f7ae80b2
│ 
│   with data.aws_ami.ubuntu,
```
- Temporary solution: hardcode `ami` value from https://cloud-images.ubuntu.com/locator/ec2/
