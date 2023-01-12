
<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Module name

## Usage

See examples folder for code ./examples/intel-optimized-postgresql-server/main.tf

Example of main.tf

```hcl
# Example of how to pass variable for admin_password:
# terraform apply -var="admin_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

# Provision Intel Cloud Optimization Module
module "azure-vm" {
  source = "../../"
  tags = {
    Name     = "my-test-vm"
    Owner    = "OwnerName",
    Duration = "2"
  }
}
```

Run Terraform

```hcl
terraform init  
terraform plan
terraform apply

```

Note that this example may create resources. Run `terraform destroy` when you don't need these resources anymore.

## Considerations  

'''
When admin_password is specified disable_password_authentication must be set to false

Either admin_password or admin_ssh_key must be specified

max_bid_price can only be configured if priority is set to Spot



'''