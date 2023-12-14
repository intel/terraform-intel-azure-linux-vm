data "azurerm_resource_group" "rg" {
  name = var.azurerm_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.azurerm_virtual_network_name
  resource_group_name = var.virtual_network_resource_group_name
}

data "azurerm_subnet" "example" {
  name                 = var.azurerm_subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_storage_account" "example" {
  count               = var.azurerm_storage_account_name != null ? 1 : 0
  name                = var.azurerm_storage_account_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_interface" "nic" {
  name                = var.azurerm_network_interface_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = var.azurerm_resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = var.ip_configuration_private_ip_address_allocation
    public_ip_address_id          = var.ip_configuration_public_ip_address_id
  }
}

################################################################################
# For Azure Key Vault
################################################################################

  data "azurerm_client_config" "current" {}

  resource "azurerm_key_vault" "example" {
  name                        = "ds-tdx-examplekeyvault"
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = var.azurerm_resource_group_name
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
# Virtual Machine
################################################################################

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = var.vm_name
  resource_group_name             = var.azurerm_resource_group_name
  location                        = data.azurerm_resource_group.rg.location
  #Specify Zone = 3 if using Intel Confidential Compute VMs with TDX. Check availblity of Intel TDX CC VMs regions and zones
  zone                            = var.tdx_flag == true ? 3: null
  size                            = var.virtual_machine_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  tags                            = var.tags
  network_interface_ids           = [azurerm_network_interface.nic.id]
  priority                        = var.priority
  disable_password_authentication = var.disable_password_authentication
  #These next three parameters are required or TDX VMs
  vtpm_enabled                    = var.tdx_flag == true ? true: null
  encryption_at_host_enabled      = var.tdx_flag == true ? true: null
  secure_boot_enabled             = var.tdx_flag == true ? true: null
  os_disk {
    name                      = var.os_disk_name
    caching                   = var.os_disk_caching
    storage_account_type      = var.os_disk_storage_account_type
    disk_size_gb              = var.disk_size_gb
    write_accelerator_enabled = var.write_accelerator_enabled
    #This is required for TDX VM
    #security_encryption_type  = "VMGuestStateOnly"
    security_encryption_type  =  var.tdx_flag == true ? "VMGuestStateOnly": null
 }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.azurerm_storage_account_name != null ? data.azurerm_storage_account.example.0.primary_blob_endpoint : null

    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key
    content {
      username   = lookup(admin_ssh_key.value, "username", null)
      public_key = lookup(admin_ssh_key.value, "public_key", null)
    }
  }

  dynamic "identity" {
    for_each = var.identity != [] ? [var.identity] : []
    content {
      identity_ids = lookup(identity.value, "identity_ids", null)
      principal_id = lookup(identity.value, "principal_id", null)
      tenant_id    = lookup(identity.value, "tenant_id", null)
      type         = lookup(identity.value, "type", null)
    }
  }
}
