
<p align="center">
  https://github.com/intel/terraform-intel-azure-linux-vm/blob/main/images/logo-classicblue-800px.png?raw=true
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Module name
Azure Linux Virtual Machine

## Terraform Intel Azure VM - Linux VM Creating Spot Virtual Machine

This example creates a Spot Azure Virtual Machine on Intel Icelake CPU on Linux Operating System. The virtual machine is created on an Intel Icelake Standard_D2_v5 by default.

More information about Intel Linux Virtual Machines on [Azure Virtual Machine Pricing](<https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/>)

As you configure your application's environment, choose the configurations for your infrastructure that matches your application's requirements.

In this example, the virtual machine is using a preconfigured network interface, subnet, and resource group. The tags Name, Owner and Duration are added to the virtual machine when it is created.

## Usage

See examples folder for code ./examples/azure-linux-vm-spot-vm/main.tf

Example of main.tf

```hcl
# Example of how to pass variable for admin_password:
# terraform apply -var="admin_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

# Provision Intel Cloud Optimization Module

variables.tf
```hcl

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this virtual machine"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "The admin_password value must be at least 8 characters in length"
  }
}
```

main.tf
```hcl
module "azurerm_linux_virtual_machine" {
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "vnet1"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name                 = "default"
  admin_password                      = var.admin_password
  priority                            = "Spot"
  max_bid_price                       = 0.0874
  eviction_policy                     = "Deallocate"
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
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

```hcl
When admin_password is specified disable_password_authentication must be set to false

Either the admin_password or admin_ssh_key argument must be specified

The max_bid_price argument can only be configured if priority argument is set to Spot. 

Azure Spot Virtual Machines can be deployed to any region, except Microsoft Azure China 21Vianet. Pricing for Azure Spot Virtual Machines is variable, based on region and SKU. For more information, see VM pricing for [Linux](<https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/>). With variable pricing, you have option to set a max price, in US dollars (USD), using up to five decimal places.

```