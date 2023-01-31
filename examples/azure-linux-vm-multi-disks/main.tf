# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

resource "azurerm_managed_disk" "managed_disk" {
  name                 = "managed_disk"
  location             = "eastus"
  resource_group_name  = "kinder-testing"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 8
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = module.azurerm_linux_virtual_machine.virtual_machine_id
  lun                = 10
  caching            = "ReadWrite"
}

module "azurerm_linux_virtual_machine" {
  source         = "../../"
  admin_username = "admin_username"
  admin_password = var.admin_password

}

