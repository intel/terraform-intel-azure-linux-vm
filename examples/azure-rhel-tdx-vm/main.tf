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
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "vnet1"
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
  source_image_reference_publisher    = "redhat"
  source_image_reference_offer        = "rhel_test_offers"
  source_image_reference_sku          = "rhel93_tdxpreview"
  source_image_reference_version      = "latest"
    tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
  }
}   
 

