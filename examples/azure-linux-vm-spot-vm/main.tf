# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables
# Resource azurerm_linux_virtual_machine requires a preconfigured resource group, virtual network, and subnet in Azure


module "azurerm_linux_virtual_machine" {
  #source                              = "../.."
  source                              = "intel/azure-linux-vm/intel"
  azurerm_resource_group_name         = "terraform-testing-rg"
  azurerm_virtual_network_name        = "vm-vnet1"
  virtual_network_resource_group_name = "terraform-testing-rg"
  azurerm_subnet_name                 = "default"
  admin_password                      = var.admin_password
  priority                            = "Spot"
  max_bid_price                       = 0.0874
  eviction_policy                     = "Deallocate"
  source_image_reference = {
    "offer"     = "0001-com-ubuntu-server-jammy"
    "sku"       = "22_04-lts-gen2"
    "publisher" = "Canonical"
    "version"   = "latest"
  }
  tags = {
    "owner"    = "user@company.com"
    "duration" = "1"
  }
}