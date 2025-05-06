
<p align="center">
   <img src="https://github.com/intel/terraform-intel-azure-linux-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2025, Intel Corporation

## Terraform Intel Azure Linux TDX VM
This example creates an Azure Virtual Machine on Intel® 4th Generation Xeon® Scalable Sapphire Rapids, processors featuring Intel Trusted Domain Extensions (TDX) on RHEL OS. These TDX Intel Confidential Computing VMs are hardned from the cloud virtualized environment by denying the hypervisor, other host management code and administrators access to the VM memory and state. The virtual machine is created on an Azure Standard_DC2es_v5 by default (currently in Azure Preview, thus make sure you have access to it and is available in your region).

Supported Intel Confidential Computing VMs with Intel TDX include:
-DCesv5-series
-DCedsv5-series
-ECesv5-series
-ECedsv5-series

See root policies.md for full list of Intel Confidential VMs with TDX.

Azure VM Security Type will be set to Confidential amd Virtualized Trusted Platform Module (vTPM) enabled as requried with optional Secure Boot, OS disk encrypted at host.

As you configure your application's environment, choose the configurations for your infrastructure that matches your application's requirements. 

In this example, the virtual machine is using a preconfigured network interface, subnet, and resource group and has an additional option to enable boot diagnostics. Make sure to the resource group is in the region where Intel Confidential Compute VMs with TDX is available. 

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
# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables
# Resource azurerm_linux_virtual_machine requires a preconfigured resource group, virtual network, and subnet in Azure - make sure the Azure region supports Intel Confidential VMs with TDX

################################################################################
# For Azure Key Vault - This is Optional
################################################################################
#data "azurerm_resource_group" "rg" {
#  name = "terraform-testing-rg"
#}

  data "azurerm_client_config" "current" {}

  resource "azurerm_key_vault" "example" {
  name                        = "tdxkeyvault"
  resource_group_name         = "terraform-testing-rg"
  location                    = "eastus2"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

key_permissions = [
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update",
      "GetRotationPolicy",
      "SetRotationPolicy"
    ]

    secret_permissions = [
      "Set",
    ]
    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_key" "generated" {
  name         = "generated-certificate"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}

################################################################################
# For Azure Virtual Machine - Required
################################################################################

module "azurerm_linux_virtual_machine" {
  source                              = "../.."
  #source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "vm-vnet1"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name                 = "default"
  virtual_machine_size                = "Standard_DC2es_v5"
  vm_name                             = "tdx-linuxvm1"
  admin_password                      = var.admin_password
  #Set to flag below to use Intel Confidential VM with TDX
  tdx_flag                            = true
  secure_boot_flag                    = true
  encryption_at_host_flag             = true
  #Chose the images supporting Intel Confidential Compute VMs with Intel TDX
  source_image_reference = {
    "offer"     = "rhel_test_offers"
    "sku"       = "rhel93_tdxpreview"
    "publisher" = "redhat"
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