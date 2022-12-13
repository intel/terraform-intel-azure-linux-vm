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
  name                 = var.subnet_name
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.subnet_prefix
}

resource "azurerm_network_interface" "example" {
  name                = var.nic_name
  location            = azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = var.ip_configuration_name
    #subnet_id                     = var.ip_configuration_subnet_id
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
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.virtual_machine_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
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
}
