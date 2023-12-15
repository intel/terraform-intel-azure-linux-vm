
<p align="center">
   <img src="https://github.com/intel/terraform-intel-azure-linux-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel Azure Linux TDX VM
This example creates an Azure Virtual Machine on Intel® 4th Generation Xeon® Scalable, Sapphire Rapids, processors featuring Intel Trusted Domain Extensions (TDX). Thse TDX Intel Confidential Computing VMs are hardned from the cloud virtualized environment by denying the hypervisor, other host management code and administrators access to the VM memory and state. The virtual machine is created on an Azure   Standard_DC2es_v5 by default.

Supported Intel Confidential Computing VMs with Intel TDX include:
-DCesv5-series
-DCedsv5-series
-ECesv5-series
-ECedsv5-series

See root policies.md for full list of Intel Confidential VMs with TDX.

Azure VM Security Type will be set to Confidential amd Virtualized Trusted Platform Module (vTPM) enabled as requried with optional Secure Boot, OS disk encrypted at host.

As you configure your application's environment, choose the configurations for your infrastructure that matches your application's requirements. 

In this example, the virtual machine is using a preconfigured network interface, subnet, and resource group and has an additional option to enable boot diagnostics. Make sure to the resoruce group is in the region where Intel Confidential Compute VMs with TDX is available. 

The tags Name, Owner and Duration are added to the virtual machine when it is created.




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
module "azurerm_linux_virtual_machine" {
  #source                              = "intel/azure-linux-vm/intel"
  source                              = "../../"
  azurerm_resource_group_name         = var.azurerm_resource_group_name
  azurerm_virtual_network_name        = var.azurerm_virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  azurerm_subnet_name                 = var.azurerm_subnet_name
  admin_password                      = var.admin_password
  virtual_machine_size                = var.virtual_machine_size
  vm_name                             = var.vm_name
  #Set to flag below to use Intel Confidential VM with TDX
  tdx_flag                            = true
  secure_boot_flag                    = true
  encryption_at_host_flag             = true
  #Chose the images supporting Intel Confidential Compute VMs with Intel TDX
  source_image_reference_publisher    = "Canonical"
  source_image_reference_offer        = "0001-com-ubuntu-confidential-vm-jammy"
  source_image_reference_sku          = "22_04-lts-cvm"
  source_image_reference_version      = "latest"
    tags = {
    "owner"    = "dave.shrestha@intel.com"
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
Intel Confidential VM with TDX is not yet supported in all Azure Regions and Availability Zones. Thus, please make sure to  check which regions are supoprted. By defualt this example uses Azure East US 2 region but you can change it in the variables.tf

When admin_password is specified disable_password_authentication must be set to false

Either admin_password or admin_ssh_key must be specified


```