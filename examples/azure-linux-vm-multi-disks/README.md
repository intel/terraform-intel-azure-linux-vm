
<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
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
  type        = string
  default     = null
  sensitive   = true
}
```

main.tf
```hcl
module "azure-vm" {
  source                         = "github.com/intel/terraform-intel-azure-linux-virtual-machine"
  azurerm_resource_group_name    = "example_resource_group"
  azurerm_virtual_network_name   = "example_virtual_network_name"
  azurerm_network_interface_name = "example_network_interface"
  admin_password                 = var.admin_password
  size                           = "Standard_D2_v5"
  location                       = "eastus"
  name                           = "example_vm"
  network_interface_ids = [
    azurerm_network_interface.example.id
  ]
  os_disk {
  }
  
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

```hcl
When admin_password is specified disable_password_authentication must be set to false

Either admin_password or admin_ssh_key must be specified

Only Managed Disks are supported via this separate resource, Unmanaged Disks can be attached using the storage_data_disk block in the azurerm_virtual_machine resource.

```