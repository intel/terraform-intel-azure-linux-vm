
<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel Azure VM - Linux VM Creating Multiple Disks

This example creates multiple disks on an Azure Virtual Machine on Intel Icelake CPU on Linux Operating System. 

This example creates a network interface, managed disk, and data disk attachment. 

In this example, the tags Name, Owner and Duration are added to the EC2 instance when it is created.

## Usage

** See examples folder for code ./examples/azure-linux-multi-disks/main.tf **
variables.tf
```hcl
variable "admin_password" {
  description = "Password for the admin user"
  type        = string
  sensitive   = true
}

```
main.tf
```hcl

resource 

resource "azurerm_network_interface" "nic" {
  name                = var.azurerm_network_interface_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = var.azurerm_resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = var.ip_configuration_private_ip_address_allocation
    public_ip_address_id          = var.ip_configuration_public_ip_address_id
  }
}

"azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm.id
  lun                = 10
  caching            = "ReadWrite"
}

module "azure-vm" {
  source = "../../"
  admin_password        = var.admin_password
  admin_username        = "adminuser"
  location              = "eastus"
  name                  = "example_vm"
  network_interface_ids = [azurerm_network_interface.nic.id]
  resource_group_name   = "example_resource_group"
  size                  = "Standard_D2_v5"

   os_disk {
    name                 = "os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
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

'''
When admin_password is specified disable_password_authentication must be set to false

Either admin_password or admin_ssh_key must be specified


Only Managed Disks are supported via this separate resource, Unmanaged Disks can be attached using the storage_data_disk block in the azurerm_virtual_machine resource.


'''