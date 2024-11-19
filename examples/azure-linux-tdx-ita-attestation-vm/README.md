
<p align="center">
   <img src="https://github.com/intel/terraform-intel-azure-linux-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2024, Intel Corporation

## Terraform Intel Azure Linux TDX VM with Intel Trust (Tiber) Autority Attestation (ITA)
This example creates an Azure Virtual Machine on Intel® 4th Generation Xeon® Scalable Sapphire Rapids processors featuring Intel Trusted Domain Extensions (TDX) and also installs all Intel Trust Authority (ITA) client and its CLI with your ITA Token (you will need to add yoru ITA token in the ita-recipe.yml file). These TDX Intel Confidential Computing VMs are hardned from the cloud virtualized environment by denying the hypervisor, other host management code and administrators access to the VM memory and state. The virtual machine is created on an Azure Standard_DC2es_v5 by default.

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

variable "azurerm_resource_group_name" {
  description = "Name of the resource group to be imported"
  type        = string
  default     = "terraform-testing-rg"
}

variable "region" {
  description = "Target Azure region to deploy VM in."
  type        = string
  default     = "eastus2"
}

variable "azurerm_virtual_network_name" {
  description = "Name of the preconfigured virtual network"
  type        = string
  default     = "vm-vnet1"
}

variable "virtual_network_resource_group_name" {
  description = "Name of the resource group of the virtual network"
  type        = string
  default     = "terraform-testing-rg"
}

variable "azurerm_subnet_name" {
  description = "The name of the preconfigured subnet"
  type        = string
  default     = "default"
}

variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this virtual machine"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "The admin_password value must be at least 8 characters in length"
  }
}

##OTHER Variables that will be created by this module
variable "azurerm_key_vault" {
  description = "Name of the Azure Key Vault"
  type        = string
  default     = "aiopeanchatqnatdxkv"
}

variable "azurazurerm_key_vault_key" {
  description = "Name of the Azure Key Vault Key"
  type        = string
  default     = "generated-certificate"
}

```

main.tf
```hcl

######################################################################################################################################
#Cloud-init is a commonly-used startup configuration utility for cloud compute instances to run the ansible playbook
######################################################################################################################################

data "cloudinit_config" "ansible" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud_init.yml"
    content_type = "text/cloud-config"
    content = templatefile("cloud_init.yml", {})

  }
}

################################################################################
# For Azure Virtual Machine - Required
################################################################################

module "azurerm_linux_virtual_machine" {
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = var.azurerm_resource_group_name
  azurerm_virtual_network_name        = var.azurerm_virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  azurerm_subnet_name                 = var.azurerm_subnet_name
  virtual_machine_size                = "Standard_DC2es_v5"
  vm_name                             = "tdx-linuxvm1"
  admin_password                      = var.admin_password
  
  #Calling the ITA-Ansible Recipe:
  custom_data                         = data.cloudinit_config.ansible.rendered
  
  #Set to flag below to use Intel Confidential VM with TDX
  tdx_flag                            = true
  secure_boot_flag                    = true
  encryption_at_host_flag             = true
   
  #Choose the images supporting Intel Confidential Compute VMs with Intel TDX
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

Run the Terraform Commands below to deploy

```Shell
terraform init
terraform plan
terraform apply
```
## Links
[Intel® Opotimized Recipes](https://github.com/intel/optimized-cloud-recipes/tree/main/recipes)
[Intel® Trust Authority](https://www.intel.com/content/www/us/en/security/trust-authority.html)
[Intel® Trust Authority Attestation Client CLI](https://docs.trustauthority.intel.com/main/articles/integrate-go-tdx-cli.html)