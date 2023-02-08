# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables
# Resource azurerm_managed_disk requires a preconfigured resource group in Azure
# Resource azurerm_linux_virtual_machine requires a preconfigured resource group, virtual network, and subnet in Azure


resource "azurerm_managed_disk" "managed_disk" {
  name                 = "managed_disk"
  location             = "eastus"
  resource_group_name  = "example_resource_group"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 8
  tags = {
    "owner" = "user@company.com"
  }
}


resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  virtual_machine_id = module.azurerm_linux_virtual_machine.virtual_machine_id
  lun                = 10
  caching            = "ReadWrite"
}

module "azurerm_linux_virtual_machine" {
  source                         = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name    = "example_resource_group"
  azurerm_virtual_network_name   = "example_virtual_network_name"
  azurerm_network_interface_name = "example_network_interface"
  admin_username                 = "admin_username"
  admin_password                 = var.admin_password

  tags = {
    "owner" = "user@company.com"
  }
}

