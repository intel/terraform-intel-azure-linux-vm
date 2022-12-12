data "azurerm_resource_group" "example" {
  name = var.azurerm_resource_group

}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
  #tags     = var.tags
}

resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.vnet_tags
}

resource "azurerm_subnet" "example" {
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
}

resource "azurerm_network_interface" "example" {
  name                = var.nic_name
  location            = azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.ip_configuration_subnet_id
    private_ip_address_allocation = var.ip_configuration_private_ip_address_allocation
    public_ip_address_id          = var.ip_configuration_public_ip_address_id
  }
  dns_servers                   = var.dns_servers
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking
  internal_dns_name_label       = var.internal_dns_name_label
  tags                          = var.tags
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.size
  #subscription_id     = var.azure-subscription-id
  #client_id           = var.azure-client-id
  #client_secret       = var.azure-client-secret
  #tenant_id           = var.azure-tenant-id

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  username = var.admin_username
  password = var.admin_password

  disable_password_authentication = false

  os_disk {
    name                      = var.os_disk_name
    caching                   = var.os_disk_caching
    storage_account_type      = var.os_disk_storage_account_type
    disk_size_gb              = var.disk_size_gb
    write_accelerator_enabled = var.enable_os_disk_write_accelerator
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }
  size {
    type        = string
    description = "The SKU which should be used for this Virtual Machine"
    size        = "Standard_D2_v5"
  }

}
