data "azurerm_resource_group" "rg" {
  name = var.azurerm_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "example" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_interface" "example" {
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

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.vm_name
  resource_group_name = var.azurerm_resource_group_name
  location            = data.azurerm_resource_group.rg.location
  size                = var.virtual_machine_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = var.tags
  network_interface_ids           = [azurerm_network_interface.example.id]

  disable_password_authentication = false

  os_disk {
    name                      = var.os_disk_name
    caching                   = var.os_disk_caching
    storage_account_type      = var.os_disk_storage_account_type
    disk_size_gb              = var.disk_size_gb
    write_accelerator_enabled = var.write_accelerator_enabled
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }
}
