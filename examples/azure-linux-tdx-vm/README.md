
<p align="center">
   <img src="https://github.com/intel/terraform-intel-azure-linux-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2025, Intel Corporation

## Terraform Intel Azure Linux TDX VM
This example creates an Azure Virtual Machine on Intel® 5th Generation Xeon® Scalable Emerald Rapids, processors featuring Intel Trusted Domain Extensions (TDX). These TDX Intel Confidential Computing VMs are hardned from the cloud virtualized environment by denying the hypervisor, other host management code and administrators access to the VM memory and state. 

- **Standard_DCes_v6 is currently in Azure Public Preview, thus make sure your subscription has access to it and is available in your region.**
--These VMs are available in West Europe, East US, West US, and West US 3 as of April 2025--

Supported Intel Confidential Computing VMs with Intel TDX include:
-DCesv6-series: Intel® 5th Generation Xeon® Scalable Emerald Rapids processors (Public Preview)
-DCedsv5-series: Intel® 4th Generation Xeon® Scalable Sapphire Rapids processors
-ECesv6-series: Intel® 5th Generation Xeon® Scalable Emerald Rapids processors (Public Preview)

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
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "vnet1"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name                 = "default"
  virtual_machine_size                = "Standard_DC2es_v6"
  vm_name                             = "tdx-linuxvm1"
  admin_password                      = var.admin_password
  #Set to flag below to use Intel Confidential VM with TDX
  tdx_flag                            = true
  secure_boot_flag                    = true
  encryption_at_host_flag             = true
  #Chose the images supporting Intel Confidential Compute VMs with Intel TDX
  source_image_reference = {
    "offer"     = "0001-com-ubuntu-confidential-vm-jammy"
    "sku"       = "22_04-lts-cvm"
    "publisher" = "Canonical"
    "version"   = "latest"
  }
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
Intel Confidential VM with TDX is not yet supported in all Azure Regions and Availability Zones. Thus, please make sure to  check which regions are supoprted. By defualt this example uses Azure East US 2 region but you can change it in the variables.tf

When admin_password is specified disable_password_authentication must be set to false

Either admin_password or admin_ssh_key must be specified


```