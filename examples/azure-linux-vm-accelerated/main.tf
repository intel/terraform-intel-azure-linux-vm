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

resource "azurerm_managed_disk" "managed_disk" {
  name                 = var.managed_disk_name
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = var.azurerm_resource_group_name
  storage_account_type = var.managed_disk_storage_account_type
  create_option        = var.managed_disk_create_option
  disk_size_gb         = var.managed_disk_size_gb
  image_reference_id   = var.managed_disk_image_reference_id
  tags                 = var.tags
  #   disk_iops_read_write = var.managed_disk_iops_read_write
  #   disk_mbps_read_write = var.managed_disk_mbps_read_write
  #   upload_size_bytes    = var.managed_disk_upload_size_bytes
  #   edge_zone            = var.managed_disk_edge_zone
  #   hyper_v_generation   = var.managed_disk_hyper_v_generation
  #   gallery_image_reference_id = var.managed_disk_gallery_image_reference_id
  #   logical_sector_size  = var.managed_disk_logical_sector_size
  #   os_size              = var.managed_disk_os_type
  #   source_resource_id   = var.managed_disk_source_resource_id 
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                  = var.vm_name
  resource_group_name   = var.azurerm_resource_group_name
  location              = data.azurerm_resource_group.rg.location
  size                  = var.virtual_machine_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  tags                  = var.tags
  network_interface_ids = [azurerm_network_interface.example.id]

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
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm.id
  lun                = var.lun
  caching            = var.os_disk_caching
}
