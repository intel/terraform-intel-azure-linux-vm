#This example deploys a Intel TDX-Capable Azure Virtual Machine (Standard_DC8es_v6) with Intel Trust Authority Attestation (ITA)
#In order for you to use this example, you will need to have registered with Intel Trust Authority and have created your ITA Token
#This example uses Terraform in combination with Cloud-Init and Ansible to deploty the Azure TDX VM and to configure ITA
 
################################################################################
# For Azure Key Vault - This is section is Optional can can be removed 
################################################################################
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                        = var.azurerm_key_vault
  resource_group_name         = var.azurerm_resource_group_name
  location                    = var.region
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
  name         = var.azurazurerm_key_vault_key
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

######################################################################################################################################
# REQUIRED: Cloud-init configuration utility for cloud compute instances to run the ansible playbook
######################################################################################################################################
locals {
  config_json = templatefile("${path.module}/config.json.tftpl", {
    trustauthority_api_key = var.trustauthority_api_key
  })
}

data "cloudinit_config" "ansible" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud_init.yml"
    content_type = "text/cloud-config"
    content = templatefile("cloud_init.yml", {
      trustauthority_api_key = var.trustauthority_api_key,
      config_json_content = local.config_json
    })
  }
}

################################################################################
# REQUIRED: For Azure Virtual Machine with Intel TDX and ITA - Required
################################################################################

module "azurerm_linux_virtual_machine" {
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = var.azurerm_resource_group_name
  azurerm_virtual_network_name        = var.azurerm_virtual_network_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  azurerm_subnet_name                 = var.azurerm_subnet_name
  virtual_machine_size                = "Standard_DC8es_v6"
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

