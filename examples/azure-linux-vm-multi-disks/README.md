
<p align="center">
  https://github.com/intel/terraform-intel-azure-linux-vm/blob/main/images/logo-classicblue-800px.png?raw=true
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel Azure VM - Linux VM Creating Multiple Disks

This example creates multiple disks on an Azure virtual machine on Intel Icelake CPU on Linux Operating System. The virtual machine is created on an Intel Icelake Standard_D2_v5 by default.

As you configure your application's environment, choose the configurations for your infrastructure that matches your application's requirements.

In this example, the virtual machine is using a preconfigured network interface, subnet, and resource group. The tags Name, Owner and Duration are added to the virtual machine when it is created.

## Usage

** See examples folder for code ./examples/azure-linux-multi-disks/main.tf **

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
resource "azurerm_managed_disk" "managed_disk" {
  name                 = "managed_disk_name"
  resource_group_name  = "terraform-testing-rg"
  storage_account_type = "Standard_LRS"
  location = "eastus"
  create_option        = "Empty"
  disk_size_gb         = 8
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = module.azurerm_linux_virtual_machine.virtual_machine_id
  lun                = 10
  caching            = "ReadWrite"
}

module "azurerm_linux_virtual_machine" {
  source                         = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name    = "terraform-testing-rg"
  azurerm_virtual_network_name   = "vnet01"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name            = "default"
  admin_password                 = var.admin_password

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

Either admin_password or admin_ssh_key must be specified

Only Managed Disks are supported via this separate resource, Unmanaged Disks can be attached using the storage_data_disk block in the azurerm_virtual_machine resource.

```