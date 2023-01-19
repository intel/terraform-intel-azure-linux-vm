variable "prefix" {
  default = "example"
}

locals {
  vm_name = "${var.prefix}-vm"
}


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

resource "azurerm_managed_disk" "managed_disk" {
  name                 = var.managed_disk_name
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = var.azurerm_resource_group_name
  storage_account_type = var.managed_disk_storage_account_type
  create_option        = var.managed_disk_create_option
  disk_size_gb         = var.managed_disk_size_gb
  image_reference_id   = var.managed_disk_image_reference_id
  tags                 = var.tags
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                  = var.vm_name
  resource_group_name   = var.azurerm_resource_group_name
  location              = data.azurerm_resource_group.rg.location
  size                  = var.virtual_machine_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  tags                  = var.tags
  network_interface_ids = [azurerm_network_interface.nic.id]

  disable_password_authentication = var.disable_password_authentication

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key
    content {
      username   = lookup(admin_ssh_key.value, "username", null)
      public_key = lookup(admin_ssh_key.value, "public_key", null)
    }
  }

}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm.id
  lun                = var.lun
  caching            = var.os_disk_caching
}
