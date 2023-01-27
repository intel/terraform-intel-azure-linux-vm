# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

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

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm.id
  lun                = var.lun
  caching            = var.os_disk_caching
}

module "azurerm_linux_virtual_machine" {
  source            = "../../"
  admin_username    = "admin_username"
  admin_password       = var.admin_password

  # Set the source_image_reference below based on your naming conventions. The value for source_image_reference provided below is for example illustration purposes only
  source_image_reference_offer     = "0001-com-ubuntu-server-lunar"
  source_image_reference_sku       = "23_04-lts-gen2"

}